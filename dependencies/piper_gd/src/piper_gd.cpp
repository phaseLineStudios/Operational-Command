/**
 * @file piper_gd.cpp
 * @author Eirik "Tapawingo"
 * @brief Godot RefCounted wrapper around the Piper TTS engine.
 * 
 * This class provides methods to set up the Piper TTS engine,
 * select voices, and synthesize speech to WAV files or audio streams.
 * 
 */

#include "piper_gd.h"

#include <cstdint>
#include <cstring>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/audio_stream_wav.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/project_settings.hpp>


using namespace godot;

void PiperTTS::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_piper_path","path"), &PiperTTS::set_piper_path);
    ClassDB::bind_method(D_METHOD("set_voice","model","config"), &PiperTTS::set_voice);
    ClassDB::bind_method(D_METHOD("synthesize_to_file","text","wav_path","opts"), &PiperTTS::synthesize_to_file, DEFVAL(Dictionary()));
    ClassDB::bind_method(D_METHOD("synthesize_to_stream","text","opts"), &PiperTTS::synthesize_to_stream, DEFVAL(Dictionary()));
    ClassDB::bind_method(D_METHOD("is_ready"), &PiperTTS::is_ready);
}

void PiperTTS::set_piper_path(const String &path) { piper_path = path; }
void PiperTTS::set_voice(const String &model, const String &config) { model_path = model; config_path = config; }
bool PiperTTS::is_ready() const { return !piper_path.is_empty() && !model_path.is_empty(); }

bool PiperTTS::synthesize_to_file(const String &text, const String &wav_path, const Dictionary &opts) {
    ERR_FAIL_COND_V_MSG(!is_ready(), false, "Piper path/model not set.");

    String tmp_txt = OS::get_singleton()->get_cache_dir()
        .path_join(String::num_uint64(Time::get_singleton()->get_ticks_usec()) + ".txt");

    {
        Ref<FileAccess> f = FileAccess::open(tmp_txt, FileAccess::WRITE);
        ERR_FAIL_COND_V(f.is_null(), false);
        f->store_string(text);
    }

    PackedStringArray args;
    args.push_back("--model");       args.push_back(model_path);
    if (!config_path.is_empty()) { args.push_back("--config"); args.push_back(config_path); }
    args.push_back("--input-file");  args.push_back(tmp_txt);
    args.push_back("--output-file"); args.push_back(wav_path);

    auto push_opt = [&](const char *flag, const char *key) {
        if (opts.has(key)) { args.push_back(flag); args.push_back(String(opts[key])); }
    };
    push_opt("--speaker", "speaker");
    push_opt("--length-scale", "length_scale");
    push_opt("--noise-scale", "noise_scale");
    push_opt("--noise-w-scale", "noise_w");

    Array output;
    int exit_code = OS::get_singleton()->execute(piper_path, args, output, true, false);

    DirAccess::remove_absolute(tmp_txt);

    if (exit_code != 0) {
        UtilityFunctions::printerr("Piper exit code: ", exit_code, " output: ", output);
        return false;
    }
    return FileAccess::file_exists(wav_path);
}

Ref<AudioStreamWAV> PiperTTS::synthesize_to_stream(const String &text, const Dictionary &opts) {
    const String tmp_wav = OS::get_singleton()->get_cache_dir()
        .path_join(String::num_uint64(Time::get_singleton()->get_ticks_usec()) + ".wav");

    if (!synthesize_to_file(text, tmp_wav, opts)) {
        return Ref<AudioStreamWAV>();
    }

    Ref<FileAccess> f = FileAccess::open(tmp_wav, FileAccess::READ);
    if (f.is_null()) {
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    auto read_tag = [&](char (&buf)[4]) {
        buf[0] = buf[1] = buf[2] = buf[3] = 0;
        f->get_buffer(reinterpret_cast<uint8_t *>(buf), 4);
    };

    char tag[4];
    read_tag(tag);
    if (std::memcmp(tag, "RIFF", 4) != 0) {
        UtilityFunctions::printerr("Not a RIFF file: ", tmp_wav);
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    (void)f->get_32();
    read_tag(tag);
    if (std::memcmp(tag, "WAVE", 4) != 0) {
        UtilityFunctions::printerr("Not a WAVE file: ", tmp_wav);
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    uint16_t audio_format = 1;
    uint16_t channels = 1;
    uint32_t sample_rate = 22050;
    uint16_t bits_per_sample = 16;
    uint32_t data_size = 0;
    uint64_t data_pos = 0;

    while (!f->eof_reached()) {
        read_tag(tag);
        if (f->eof_reached()) break;
        const uint32_t chunk_size = f->get_32();

        if (std::memcmp(tag, "fmt ", 4) == 0) {
            audio_format     = f->get_16();
            channels         = f->get_16();
            sample_rate      = f->get_32();
            (void)f->get_32();
            (void)f->get_16();
            bits_per_sample  = f->get_16();

            const int32_t extra = int32_t(chunk_size) - 16;
            if (extra > 0) f->seek(f->get_position() + extra);
        } else if (std::memcmp(tag, "data", 4) == 0) {
            data_pos = f->get_position();
            data_size = chunk_size;
            f->seek(data_pos + data_size);
        } else {
            f->seek(f->get_position() + chunk_size);
        }
    }

    if (data_pos == 0 || data_size == 0) {
        UtilityFunctions::printerr("WAV has no data chunk: ", tmp_wav);
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    f->seek(data_pos);
    PackedByteArray pcm;
    pcm.resize(data_size);
    f->get_buffer(pcm.ptrw(), data_size);
    f.unref();

    if (!(audio_format == 1 && (bits_per_sample == 8 || bits_per_sample == 16))) {
        UtilityFunctions::printerr("Unsupported WAV format: fmt=", audio_format,
                                   " bits=", bits_per_sample, " (expect PCM 8/16-bit)");
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    Ref<AudioStreamWAV> wav; wav.instantiate();
    wav->set_mix_rate(sample_rate);
    wav->set_stereo(channels == 2);
    wav->set_format(bits_per_sample == 8 ? AudioStreamWAV::FORMAT_8_BITS
                                         : AudioStreamWAV::FORMAT_16_BITS);
    wav->set_data(pcm);

    DirAccess::remove_absolute(tmp_wav);

    return wav;
}