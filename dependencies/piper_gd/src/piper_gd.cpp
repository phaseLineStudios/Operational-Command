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

#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/callable.hpp>

#include <godot_cpp/variant/vector2.hpp>
#include <cstdint>
#include <cstring>
#include <vector>

#ifdef _WIN32
  #define NOMINMAX
  #include <windows.h>
  #include <string>
#else
  #include <unistd.h>
  #include <sys/types.h>
  #include <sys/wait.h>
  #include <fcntl.h>
  #include <signal.h>
#endif

using namespace godot;

static inline String _fs(const String &p) {
    if (p.begins_with("res://") || p.begins_with("user://"))
        return ProjectSettings::get_singleton()->globalize_path(p);
    return p;
}

namespace {
    PackedByteArray to_pba(const uint8_t *data, int len) {
        PackedByteArray a; a.resize(len);
        if (len > 0) {
            memcpy(a.ptrw(), data, len);
        }
        return a;
    }
}

PiperTTS::~PiperTTS() {
    stop_stream();
    wait();
}

void PiperTTS::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_piper_path","path"), &PiperTTS::set_piper_path);
    ClassDB::bind_method(D_METHOD("set_voice","model","config"), &PiperTTS::set_voice);
    ClassDB::bind_method(D_METHOD("is_ready"), &PiperTTS::is_ready);

    ClassDB::bind_method(D_METHOD("synthesize_to_file","text","wav_path","opts"), &PiperTTS::synthesize_to_file, DEFVAL(Dictionary()));
    ClassDB::bind_method(D_METHOD("synthesize_to_stream","text","opts"), &PiperTTS::synthesize_to_stream, DEFVAL(Dictionary()));

    ClassDB::bind_method(D_METHOD("synthesize_to_stream_async","text","opts"), &PiperTTS::synthesize_to_stream_async, DEFVAL(Dictionary()));
    ClassDB::bind_method(D_METHOD("wait"), &PiperTTS::wait);
    ClassDB::bind_method(D_METHOD("_finalize_success","id","pcm","sample_rate","channels","bits"), &PiperTTS::_finalize_success);
    ClassDB::bind_method(D_METHOD("_finalize_failure","id","message"), &PiperTTS::_finalize_failure);

    ClassDB::bind_method(D_METHOD("start_stream","exe_path","model_path","config_path","sample_rate"), &PiperTTS::start_stream, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("say_stream","text"), &PiperTTS::say_stream);
    ClassDB::bind_method(D_METHOD("set_playback","playback"), &PiperTTS::set_playback);
    ClassDB::bind_method(D_METHOD("pump"), &PiperTTS::pump);
    ClassDB::bind_method(D_METHOD("stop_stream"), &PiperTTS::stop_stream);
    ClassDB::bind_method(D_METHOD("is_stream_running"), &PiperTTS::is_stream_running);

    ClassDB::add_signal(PiperTTS::get_class_static(),
        MethodInfo("synthesis_completed",
            PropertyInfo(Variant::INT, "id"),
            PropertyInfo(Variant::OBJECT, "stream", PROPERTY_HINT_RESOURCE_TYPE, "AudioStreamWAV")));
    ClassDB::add_signal(PiperTTS::get_class_static(),
        MethodInfo("synthesis_failed",
            PropertyInfo(Variant::INT, "id"),
            PropertyInfo(Variant::STRING, "message")));
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
    args.push_back("--model");       args.push_back(_fs(model_path));
    if (!config_path.is_empty()) { args.push_back("--config"); args.push_back(_fs(config_path)); }
    args.push_back("--input-file");  args.push_back(tmp_txt);
    args.push_back("--output-file"); args.push_back(_fs(wav_path));

    auto push_opt = [&](const char *flag, const char *key) {
        if (opts.has(key)) { args.push_back(flag); args.push_back(String(opts[key])); }
    };
    push_opt("--speaker", "speaker");
    push_opt("--length-scale", "length_scale");
    push_opt("--noise-scale", "noise_scale");
    push_opt("--noise-w-scale", "noise_w");

    Array output;
    int exit_code = OS::get_singleton()->execute(_fs(piper_path), args, output, true, false);
    DirAccess::remove_absolute(tmp_txt);

    if (exit_code != 0) {
        UtilityFunctions::printerr("Piper exit code: ", exit_code, " output: ", output);
        return false;
    }
    return FileAccess::file_exists(_fs(wav_path));
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

int64_t PiperTTS::synthesize_to_stream_async(const String &text, const Dictionary &opts) {
    ERR_FAIL_COND_V_MSG(!is_ready(), -1, "Piper path/model not set.");
    if (_mtx.is_null()) { _mtx.instantiate(); }

    _mtx->lock();
    if (_busy) { _mtx->unlock(); return 0; }
    _busy = true;
    _job_text = text;
    _job_opts = opts;
    _job_id = _next_id++;
    _mtx->unlock();

    if (_thread.is_null()) { _thread.instantiate(); }
    _thread->start(callable_mp(this, &PiperTTS::_thread_proc));
    return _job_id;
}

void PiperTTS::wait() {
    if (_thread.is_valid() && _thread->is_started()) {
        _thread->wait_to_finish();
    }
}

void PiperTTS::_thread_proc() {
    String text; Dictionary opts; int64_t id = 0;
    _mtx->lock();
    text = _job_text; opts = _job_opts; id = _job_id;
    _mtx->unlock();

    const String tmp_wav = OS::get_singleton()->get_cache_dir()
        .path_join(String::num_uint64(Time::get_singleton()->get_ticks_usec()) + ".wav");
    if (!synthesize_to_file(text, tmp_wav, opts)) {
        call_deferred("_finalize_failure", id, String("Piper synthesis failed"));
        return;
    }

    Ref<FileAccess> f = FileAccess::open(tmp_wav, FileAccess::READ);
    if (f.is_null()) {
        call_deferred("_finalize_failure", id, String("Cannot open temp wav"));
        DirAccess::remove_absolute(tmp_wav);
        return;
    }

    auto read_tag = [&](char (&buf)[4]) {
        buf[0]=buf[1]=buf[2]=buf[3]=0;
        f->get_buffer(reinterpret_cast<uint8_t *>(buf), 4);
    };

    char tag[4]; read_tag(tag);
    if (std::memcmp(tag, "RIFF", 4) != 0) {
        DirAccess::remove_absolute(tmp_wav);
        call_deferred("_finalize_failure", id, String("Not RIFF"));
        return;
    }
    (void)f->get_32(); read_tag(tag);
    if (std::memcmp(tag, "WAVE", 4) != 0) {
        DirAccess::remove_absolute(tmp_wav);
        call_deferred("_finalize_failure", id, String("Not WAVE"));
        return;
    }

    uint16_t audio_format = 1, channels = 1;
    uint32_t sample_rate = 22050, data_size = 0;
    uint16_t bits_per_sample = 16;
    uint64_t data_pos = 0;

    while (!f->eof_reached()) {
        read_tag(tag);
        if (f->eof_reached()) break;
        const uint32_t chunk_size = f->get_32();

        if (std::memcmp(tag, "fmt ", 4) == 0) {
            audio_format     = f->get_16();
            channels         = f->get_16();
            sample_rate      = f->get_32();
            (void)f->get_32(); (void)f->get_16();
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

    if (!(audio_format == 1 && (bits_per_sample == 8 || bits_per_sample == 16)) || data_pos == 0 || data_size == 0) {
        DirAccess::remove_absolute(tmp_wav);
        call_deferred("_finalize_failure", id, String("Unsupported WAV or empty"));
        return;
    }

    f->seek(data_pos);
    PackedByteArray pcm; pcm.resize(data_size);
    f->get_buffer(pcm.ptrw(), data_size);
    f.unref();
    DirAccess::remove_absolute(tmp_wav);

    call_deferred("_finalize_success", id, pcm, (int)sample_rate, (int)channels, (int)bits_per_sample);
}

void PiperTTS::_finalize_success(int64_t id, PackedByteArray pcm, int sample_rate, int channels, int bits) {
    if (_thread.is_valid() && _thread->is_started()) _thread->wait_to_finish();
    _thread.unref();
    _busy = false;

    Ref<AudioStreamWAV> wav; wav.instantiate();
    wav->set_mix_rate(sample_rate);
    wav->set_stereo(channels == 2);
    wav->set_format(bits == 8 ? AudioStreamWAV::FORMAT_8_BITS : AudioStreamWAV::FORMAT_16_BITS);
    wav->set_data(pcm);
    emit_signal("synthesis_completed", id, wav);
}

void PiperTTS::_finalize_failure(int64_t id, const String &message) {
    if (_thread.is_valid() && _thread->is_started()) _thread->wait_to_finish();
    _thread.unref();
    _busy = false;
    emit_signal("synthesis_failed", id, message);
}

#ifdef _WIN32
static std::wstring _utf8_to_wide(const String &s) {
    CharString u8 = s.utf8();
    int needed = MultiByteToWideChar(CP_UTF8, 0, u8.get_data(), -1, nullptr, 0);
    std::wstring w; w.resize(needed);
    MultiByteToWideChar(CP_UTF8, 0, u8.get_data(), -1, w.data(), needed);
    return w;
}
#endif

bool PiperTTS::_spawn_piper_raw(const String &exe_path, const PackedStringArray &args) {
#ifdef _WIN32
    SECURITY_ATTRIBUTES sa; ZeroMemory(&sa, sizeof(sa)); sa.nLength = sizeof(sa); sa.bInheritHandle = TRUE;

    HANDLE c_out_r = nullptr, c_out_w = nullptr;
    HANDLE c_in_r = nullptr, c_in_w = nullptr;

    if (!CreatePipe(&c_out_r, &c_out_w, &sa, 0)) return false;
    if (!SetHandleInformation(c_out_r, HANDLE_FLAG_INHERIT, 0)) return false;

    if (!CreatePipe(&c_in_r, &c_in_w, &sa, 0)) return false;
    if (!SetHandleInformation(c_in_w, HANDLE_FLAG_INHERIT, 0)) return false;

    String cmd = "\"" + exe_path + "\"";
    for (int i = 0; i < args.size(); ++i) {
        cmd += " \"" + args[i].replace("\"","\\\"") + "\"";
    }
    std::wstring wcmd = _utf8_to_wide(cmd);

    STARTUPINFOW si; ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;
    si.hStdOutput = c_out_w;
    si.hStdError  = c_out_w;
    si.hStdInput  = c_in_r;

    PROCESS_INFORMATION pi; ZeroMemory(&pi, sizeof(pi));
    BOOL ok = CreateProcessW(
        nullptr, (LPWSTR)wcmd.data(),
        nullptr, nullptr, TRUE,
        CREATE_NO_WINDOW,
        nullptr, nullptr,
        &si, &pi
    );

    CloseHandle(c_out_w);
    CloseHandle(c_in_r);

    if (!ok) {
        if (pi.hProcess) CloseHandle(pi.hProcess);
        if (pi.hThread) CloseHandle(pi.hThread);
        CloseHandle(c_out_r);
        CloseHandle(c_in_w);
        return false;
    }

    _h_proc = pi.hProcess;
    _h_thread = pi.hThread;
    _h_child_stdout_r = c_out_r;
    _h_child_stdin_w  = c_in_w;
    return true;

#else
    int in_pipe[2];
    int out_pipe[2];
    if (pipe(in_pipe) != 0) return false;
    if (pipe(out_pipe) != 0) { close(in_pipe[0]); close(in_pipe[1]); return false; }

    pid_t pid = fork();
    if (pid == -1) {
        close(in_pipe[0]); close(in_pipe[1]);
        close(out_pipe[0]); close(out_pipe[1]);
        return false;
    }

    if (pid == 0) {
        dup2(in_pipe[0], STDIN_FILENO);
        dup2(out_pipe[1], STDOUT_FILENO);
        dup2(out_pipe[1], STDERR_FILENO);
        close(in_pipe[1]); close(out_pipe[0]);

        std::vector<char*> argv;
        CharString exe8 = exe_path.utf8();
        argv.push_back(const_cast<char*>(exe8.get_data()));
        std::vector<std::string> keep;
        keep.reserve(args.size());
        for (int i = 0; i < args.size(); ++i) {
            keep.emplace_back(args[i].utf8().get_data());
            argv.push_back(keep.back().data());
        }
        argv.push_back(nullptr);
        execv(argv[0], argv.data());
        _exit(127);
    }

    close(in_pipe[0]);  close(out_pipe[1]);
    _pid = pid;
    _fd_stdin  = in_pipe[1];
    _fd_stdout = out_pipe[0];
    return true;
#endif
}

void PiperTTS::_close_pipes_and_process() {
#ifdef _WIN32
    if (_h_child_stdin_w) { CloseHandle((HANDLE)_h_child_stdin_w); _h_child_stdin_w = nullptr; }
    if (_h_child_stdout_r) { CloseHandle((HANDLE)_h_child_stdout_r); _h_child_stdout_r = nullptr; }

    if (_h_proc) {
        DWORD res = WaitForSingleObject((HANDLE)_h_proc, 800);
        if (res == WAIT_TIMEOUT) {
            TerminateProcess((HANDLE)_h_proc, 0);
            WaitForSingleObject((HANDLE)_h_proc, 200);
        }
        CloseHandle((HANDLE)_h_proc); _h_proc = nullptr;
    }
    if (_h_thread) { CloseHandle((HANDLE)_h_thread); _h_thread = nullptr; }

#else
    if (_fd_stdin  >= 0) { close(_fd_stdin);  _fd_stdin  = -1; }
    if (_fd_stdout >= 0) { close(_fd_stdout); _fd_stdout = -1; }
    if (_pid > 0) { kill(_pid, SIGTERM); int st=0; waitpid(_pid, &st, 0); _pid = -1; }
#endif
}

bool PiperTTS::start_stream(const String &exe_path, const String &model, const String &config, int sample_rate) {
    if (_stream_running) return true;

    if (_buf_mutex.is_null()) _buf_mutex.instantiate();
    _byte_buf.clear(); _leftover.clear();

    _sample_rate = (sample_rate > 0) ? sample_rate : 22050;

    PackedStringArray args;
    args.push_back("--model"); args.push_back(_fs(model));
    if (!config.is_empty()) { args.push_back("--config"); args.push_back(_fs(config)); }
    args.push_back("--output-raw");

    bool ok = _spawn_piper_raw(_fs(exe_path), args);
    if (!ok) return false;

    _stream_running = true;
    _reader_thread.instantiate();
    _reader_thread->start(callable_mp(this, &PiperTTS::_reader_loop));
    return true;
}

void PiperTTS::stop_stream() {
    if (!_stream_running) return;
    _stream_running = false;

    _close_pipes_and_process();

    if (_reader_thread.is_valid() && _reader_thread->is_started())
        _reader_thread->wait_to_finish();
    _reader_thread.unref();


    if (_buf_mutex.is_valid()) {
        _buf_mutex->lock();
        _byte_buf.clear();
        _leftover.clear();
        _buf_mutex->unlock();
    }
}

bool PiperTTS::say_stream(const String &text) {
    if (!_stream_running) return false;
    String line = text + String("\n");
    CharString u8 = line.utf8();
#ifdef _WIN32
    if (!_h_child_stdin_w) return false;
    DWORD written = 0;
    BOOL ok = WriteFile((HANDLE)_h_child_stdin_w, u8.get_data(), (DWORD)u8.length(), &written, nullptr);
    FlushFileBuffers((HANDLE)_h_child_stdin_w);
    return ok && written == (DWORD)u8.length();
#else
    if (_fd_stdin < 0) return false;
    ssize_t w = write(_fd_stdin, u8.get_data(), u8.length());
    return w == (ssize_t)u8.length();
#endif
}

void PiperTTS::set_playback(const Ref<AudioStreamGeneratorPlayback> &playback) {
    _playback = playback;
}

bool PiperTTS::is_stream_running() { 
    return _stream_running; 
}

void PiperTTS::pump() {
    if (_playback.is_null()) return;

    int frames_free = _playback->get_frames_available();
    if (frames_free <= 0) return;

    PackedByteArray data;
    if (_buf_mutex.is_valid()) {
        _buf_mutex->lock();
        data = _byte_buf;
        _byte_buf.clear();
        _buf_mutex->unlock();
    }

    if (_leftover.size() > 0) {
        PackedByteArray merged;
        merged.resize(_leftover.size() + data.size());
        if (_leftover.size() > 0) memcpy(merged.ptrw(), _leftover.ptr(), _leftover.size());
        if (data.size() > 0) memcpy(merged.ptrw() + _leftover.size(), data.ptr(), data.size());
        data = merged;
        _leftover.clear();
    }
    if (data.is_empty()) return;

    if (data.size() & 1) {
        _leftover.resize(1);
        _leftover[0] = data[data.size() - 1];
        data.resize(data.size() - 1);
    }

    const uint8_t *p = data.ptr();
    const int sample_count = data.size() / 2;

    int to_push = MIN(sample_count, frames_free);
    for (int i = 0; i < to_push; ++i) {
        int16_t s = (int16_t)((p[2*i+1] << 8) | p[2*i]);
        float f = Math::clamp((float)s / 32768.0f, -1.0f, 1.0f);
        _playback->push_frame(Vector2(f, f));
    }

    const int bytes_consumed = to_push * 2;
    const int bytes_total    = data.size();
    const int bytes_left     = bytes_total - bytes_consumed;
    if (bytes_left > 0 && _buf_mutex.is_valid()) {
        PackedByteArray rem;
        rem.resize(bytes_left);
        memcpy(rem.ptrw(), p + bytes_consumed, bytes_left);

        _buf_mutex->lock();
        if (_byte_buf.size() == 0) {
            _byte_buf = rem;
        } else {
            PackedByteArray merged;
            merged.resize(rem.size() + _byte_buf.size());
            memcpy(merged.ptrw(), rem.ptr(), rem.size());
            memcpy(merged.ptrw() + rem.size(), _byte_buf.ptr(), _byte_buf.size());
            _byte_buf = merged;
        }
        _buf_mutex->unlock();
    }
}

void PiperTTS::_reader_loop() {
    const int CHUNK = 8192;
    while (true) {
        if (!_stream_running) break;
#ifdef _WIN32
        if (!_h_child_stdout_r) break;
        uint8_t tmp[CHUNK];
        DWORD got = 0;
        BOOL ok = ReadFile((HANDLE)_h_child_stdout_r, tmp, CHUNK, &got, nullptr);
        if (!ok || got == 0) { 
            OS::get_singleton()->delay_msec(2); 
            continue;
        }
        if (_buf_mutex.is_valid()) { 
            _buf_mutex->lock(); 
            _byte_buf.append_array(to_pba(tmp, (int)got)); 
            _buf_mutex->unlock(); 
        }
#else
        if (_fd_stdout < 0) break;
        uint8_t tmp[CHUNK];
        ssize_t got = read(_fd_stdout, tmp, CHUNK);
        if (got <= 0) { 
            OS::get_singleton()->delay_msec(2); 
            continue; 
        }
        if (_buf_mutex.is_valid()) { 
            _buf_mutex->lock(); 
            _byte_buf.append_array(to_pba(tmp, (int)got)); 
            _buf_mutex->unlock(); 
        }
#endif
    }
}
