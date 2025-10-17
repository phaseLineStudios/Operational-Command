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

#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

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
    String tmp_wav = OS::get_singleton()->get_cache_dir()
        .path_join(String::num_uint64(Time::get_singleton()->get_ticks_usec()) + ".wav");

    if (!synthesize_to_file(text, tmp_wav, opts)) {
        return Ref<AudioStreamWAV>();
    }

    Ref<FileAccess> f = FileAccess::open(tmp_wav, FileAccess::READ);
    if (f.is_null()) {
        DirAccess::remove_absolute(tmp_wav);
        return Ref<AudioStreamWAV>();
    }

    PackedByteArray data;
    data.resize(f->get_length());
    f->get_buffer(data.ptrw(), data.size());
    DirAccess::remove_absolute(tmp_wav);

    Ref<AudioStreamWAV> wav; wav.instantiate();
    wav->set_data(data);
    return wav;
}
