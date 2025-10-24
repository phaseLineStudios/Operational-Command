/**
 * @file piper_gd.h
 * @author Eirik "Tapawingo"
 * @brief Godot GDExtension binding for the Piper TTS engine.
 * 
 * This header declares the `PiperTTS` class which exposes methods to
 * synthesize speech using the Piper TTS engine from Godot scripts.
 * 
 */

#ifndef PIPER_GD_H
#define PIPER_GD_H

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/audio_stream_wav.hpp>
#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/classes/mutex.hpp>

#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {

/**
 * @brief RefCounted wrapper around the Piper CLI.
 * @details Configure paths, then call either sync/async file-based methods,
 *          or start the persistent streaming mode for low-latency playback.
 */
class PiperTTS : public RefCounted {
    GDCLASS(PiperTTS, RefCounted);

    /**
     * @brief Path to the Piper executable.
     * @details This should point to the Piper binary used for synthesis.
     */
    String piper_path;

    /**
     * @brief Path to the selected voice model.
     * @details Filesystem path to the Piper voice model directory.
     */
    String model_path;

    /**
     * @brief Path to the voice configuration file.
     * @details Optional path to a configuration file for the selected voice.
     */
    String config_path;

    /**
     * @brief Thread for asynchronous synthesis.
     * @details Used to run synthesis jobs without blocking the main thread.
     */
    Ref<Thread> _thread;

    /**
     * @brief Mutex for thread safety.
     * @details Protects access to shared resources during synthesis.
     */
    Ref<Mutex>  _mtx;

    /**
     * @brief Busy flag indicating if a synthesis job is in progress.
     * @details Prevents starting new jobs while one is active.
     */
    bool        _busy = false;

    /**
     * @brief Next job ID counter.
     * @details Incremented for each new synthesis job to provide unique IDs.
     */
    int64_t     _next_id = 1;

    /**
     * @brief Current job text.
     * @details The text being synthesized in the current job.
     */
    String      _job_text;

    /**
     * @brief Current job options.
     * @details Dictionary of options for the current synthesis job.
     */
    Dictionary  _job_opts;

    /**
     * @brief Current job ID.
     * @details Unique identifier for the current synthesis job.
     */
    int64_t     _job_id = 0;

    /**
     * @brief Streaming state flag.
     * @details Indicates whether the streaming mode is active.
     */
    bool _stream_running = false;

    /**
     * @brief Sample rate for streaming playback.
     * @details Audio sample rate used during streaming synthesis.
     */
    int  _sample_rate = 22050;

    /**
     * @brief Thread for reading streaming audio data.
     * @details Continuously reads PCM data from the Piper process in streaming mode.
     */
    Ref<Thread> _reader_thread;

    /**
     * @brief Mutex for buffering audio data.
     */
    Ref<Mutex>  _buf_mutex;

    /**
     * @brief Buffer for incoming audio data.
     * @details Stores PCM data read from the Piper process.
     */
    PackedByteArray _byte_buf;

    /**
     * @brief Leftover bytes from previous read.
     * @details Used to handle cases where an odd number of bytes are read.
     */
    PackedByteArray _leftover;

    /**
     * @brief Playback object for streaming audio.
     * @details AudioStreamGeneratorPlayback instance for real-time audio output.
     */
    Ref<AudioStreamGeneratorPlayback> _playback;

#ifdef _WIN32
    /**
     * @brief Handles for the Piper process and its pipes on Windows.
     * @details Used to manage the Piper subprocess and its standard input/output.
     */
    void* _h_proc = nullptr;
    void* _h_thread = nullptr;
    void* _h_child_stdin_w = nullptr;
    void* _h_child_stdout_r = nullptr;
#else
    /**
     * @brief Process ID and file descriptors for pipes on Unix-like systems.
     * @details Used to manage the Piper subprocess and its standard input/output.
     */
    int   _pid = -1;
    int   _fd_stdin = -1;
    int   _fd_stdout = -1;
#endif

protected:
    /**
     * @brief Registers methods and properties with the Godot ClassDB.
     * @internal Called by Godot during class initialization.
     */
    static void _bind_methods();

    /**
     * @brief Thread procedure for asynchronous synthesis.
     */
    void _thread_proc();

    /**
     * @brief Finalizes a successful synthesis job.
     * 
     * @param id Unique job ID.
     * @param pcm Packed byte array containing PCM audio data.
     * @param sample_rate Sample rate of the synthesized audio.
     * @param channels Number of audio channels.
     * @param bits Bits per sample.
     */
    void _finalize_success(int64_t id, PackedByteArray pcm, int sample_rate, int channels, int bits);
    /**
     * @brief Finalizes a failed synthesis job.
     * 
     * @param id Unique job ID.
     * @param message Error message describing the failure.
     */
    void _finalize_failure(int64_t id, const String &message);

    /**
     * @brief Reader loop for streaming audio data.
     */
    void _reader_loop();

    /**
     * @brief Spawns the Piper process with raw output.
     * 
     * @param exe_path Path to the Piper executable.
     * @param args Arguments to pass to the Piper executable.
     */
    bool _spawn_piper_raw(const String &exe_path, const PackedStringArray &args);

    /**
     * @brief Closes pipes and terminates the Piper process.
     */
    void _close_pipes_and_process();

public:
    /**
     * @brief Deconstructor for the PiperTTS class.
     * @details Cleans up resources used by the PiperTTS instance.
     */
    ~PiperTTS();

    /**
     * @brief Sets the filesystem path to the Piper executable.
     * 
     * @param path Filesystem path to the Piper binary.
     */
    void set_piper_path(const String &path);

    /**
     * @brief Sets the voice model and configuration for synthesis.
     * 
     * @param model Filesystem path to the Piper voice model.
     * @param config Filesystem path to the voice configuration file.
     */
    void set_voice(const String &model, const String &config);

    /**
     * @brief Checks if the Piper TTS engine is properly configured.
     * 
     * @return `true` if Piper path and model are set, `false` otherwise.
     */
    bool is_ready() const;

    /**
     * @brief Synthesizes speech from text and saves it to a WAV file.
     * 
     * @param text The input text to synthesize.
     * @param wav_path Filesystem path where the output WAV file will be saved.
     * @param opts Optional dictionary of synthesis options (e.g., speaker, length_scale).
     * @return `true` if synthesis was successful and the file was created, `false` otherwise.
     */
    bool synthesize_to_file(const String &text, const String &wav_path, const Dictionary &opts = Dictionary());

    /**
     * @brief Synthesizes speech from text and returns it as an AudioStreamWAV.
     * 
     * @param text The input text to synthesize.
     * @param opts Optional dictionary of synthesis options (e.g., speaker, length_scale).
     * @return A Ref<AudioStreamWAV> containing the synthesized audio, or an empty Ref on failure.
     */
    Ref<AudioStreamWAV> synthesize_to_stream(const String &text, const Dictionary &opts = Dictionary());

    /**
     * @brief Asynchronously synthesizes speech from text to a stream.
     * 
     * @param text The input text to synthesize.
     * @param opts Optional dictionary of synthesis options (e.g., speaker, length_scale).
     * @return A unique job ID for tracking the asynchronous synthesis task.
     * 
     * @note The synthesized audio will be delivered via a signal when complete.
     */
    int64_t synthesize_to_stream_async(const String &text, const Dictionary &opts = Dictionary());

    /**
     * @brief Waits for the current asynchronous synthesis job to complete.
     * 
     * @note This method blocks until the job is finished.
     */
    void wait();

    /**
     * @brief Starts the Piper TTS engine in streaming mode.
     * 
     * @param exe_path Path to the Piper executable.
     * @param model_path Path to the voice model.
     * @param config_path Path to the voice configuration file.
     * @param sample_rate Optional sample rate for audio output (default is 22050 Hz).
     * 
     * @return `true` if streaming started successfully, `false` otherwise.
     */
    bool start_stream(const String &exe_path, const String &model_path, const String &config_path, int sample_rate = 0);

    /**
     * @brief Sends text to the Piper engine for streaming synthesis.
     * 
     * @param text The input text to synthesize.
     * @return `true` if the text was successfully sent, `false` otherwise.
     */
    bool say_stream(const String &text);

    /**
     * @brief Sets the AudioStreamGeneratorPlayback for streaming audio output.
     * 
     * @param playback Ref<AudioStreamGeneratorPlayback> instance for audio playback.
     * 
     * @note This must be called before starting streaming synthesis.
     */
    void set_playback(const Ref<AudioStreamGeneratorPlayback> &playback);

    /**
     * @brief Pumps audio data from the Piper engine into the playback buffer.
     */
    void pump();

    /**
     * @brief Stops the streaming synthesis and cleans up resources.
     */
    void stop_stream();

    /**
     * @brief Checks if the streaming mode is currently running.
     * 
     * @return `true` if streaming is active, `false` otherwise.
     */
    bool is_stream_running();
};

} // namespace godot

#endif // PIPER_GD_H