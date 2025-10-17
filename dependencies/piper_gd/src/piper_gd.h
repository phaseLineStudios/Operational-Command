/**
 * @file piper_gd.h
 * @author Eirik "Tapawingo"
 * @brief Godot GDExtension binding for the Piper TTS engine.
 * 
 * This header declares the `PiperTTS` class which exposes methods to
 * synthesize speech using the Piper TTS engine from Godot scripts.
 * 
 */

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/binder_common.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/audio_stream_wav.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

#ifndef PIPER_GD_H
#define PIPER_GD_H

namespace godot {

/**
 * @brief Godot RefCounted wrapper around the Piper TTS engine.
 * 
 * This class provides methods to set up the Piper TTS engine,
 * select voices, and synthesize speech to WAV files or audio streams.
 * 
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

protected:
    /**
     * @brief Registers methods and properties with the Godot ClassDB.
     * @internal Called by Godot during class initialization.
     */
    static void _bind_methods();

public:
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
    bool synthesize_to_file(const String &text, const String &wav_path, const Dictionary &opts);

    /**
     * @brief Synthesizes speech from text and returns it as an AudioStreamWAV.
     * 
     * @param text The input text to synthesize.
     * @param opts Optional dictionary of synthesis options (e.g., speaker, length_scale).
     * @return A Ref<AudioStreamWAV> containing the synthesized audio, or an empty Ref on failure.
     */
    Ref<AudioStreamWAV> synthesize_to_stream(const String &text, const Dictionary &opts);
};

} //namespace godot

#endif // PIPER_GD_H