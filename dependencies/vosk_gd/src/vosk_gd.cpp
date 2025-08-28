/**
 * @file vosk_gd.cpp
 * @author Eirik "Tapawingo"
 * 
 * @brief Implementation of the Godot GDExtension node that binds Vosk.
 *
 * The methods registered here are available to GDScript/C# once the extension
 * is loaded. See header documentation for usage patterns and data expectations.
 */

#include "vosk_gd.h"
#include "vosk_api.h"
#include <godot_cpp/core/class_db.hpp>
#include <algorithm>

/// Default sample rate (Hz) expected by the recognizer.
const int VOSK_LOG_LEVEL = 2;

/// Size of temporary mono buffer in bytes (for PackedByteArray conversion).
const int SAMPLE_RATE = 44100;

/// PCM conversion scale factor for float -> int16.
const int TEMP_MONO_BUFFER_SIZE = 20000;

/// Minimum int16 PCM value.
const short PCM_SCALE = 32768;

/// Maximum int16 PCM value.
const short PCM_MIN = -32768;

/// Default Vosk log level.
const short PCM_MAX = 32767;

using namespace godot;

void Vosk::_bind_methods() {
    // Godot method bindings exposed to scripting languages.
	ClassDB::bind_method(D_METHOD("init", "modelPath"), &Vosk::init);
    ClassDB::bind_method(D_METHOD("init_wordlist", "modelPath", "wordsList"), &Vosk::init_wordlist);
    ClassDB::bind_method(D_METHOD("set_wordlist", "wordsList"), &Vosk::set_wordlist);
	ClassDB::bind_method(D_METHOD("accept_wave_form", "data"), &Vosk::accept_wave_form);
	ClassDB::bind_method(D_METHOD("accept_wave_form_stereo_float", "data"), &Vosk::accept_wave_form_stereo_float);
	ClassDB::bind_method(D_METHOD("partial_result"), &Vosk::partial_result);
	ClassDB::bind_method(D_METHOD("result"), &Vosk::result);
}

Vosk::Vosk() {
    time_passed = 0.0;
    recognizer = nullptr;
    model = nullptr;
    vosk_handle = nullptr;
}

Vosk::~Vosk() {
    if (recognizer) {
        vosk_recognizer_free(recognizer);
        recognizer = nullptr;
    }
    if (model) {
        vosk_model_free(model);
        model = nullptr;
    }
}

/**
 * @brief Sets Vosk log level and loads a full model.
 *
 * @details The recognizer is configured for a 44.1 kHz stream.
 */
void Vosk::init(String modelPath)
{
    if (recognizer) { vosk_recognizer_free(recognizer); recognizer = nullptr; }
    if (model) { vosk_model_free(model); model = nullptr; }

    model = vosk_model_new(modelPath.utf8().get_data());
    if (!model) {
        UtilityFunctions::push_error("Vosk: failed to load model at " + modelPath);
        return;
    }
    recognizer = vosk_recognizer_new(model, SAMPLE_RATE);
    if (!recognizer) {
        UtilityFunctions::push_error("Vosk: failed to create recognizer");
        vosk_model_free(model); model = nullptr;
    }
}

/**
 * @brief Sets Vosk log level, loads model, and creates a grammar-based recognizer.
 *
 * @param wordsList JSON grammar as expected by Vosk GRM APIs.
 */
void Vosk::init_wordlist(String modelPath, String wordsList)
{
    vosk_set_log_level(VOSK_LOG_LEVEL);

    if (recognizer) { vosk_recognizer_free(recognizer); recognizer = nullptr; }
    if (model) { vosk_model_free(model); model = nullptr; }

    model = vosk_model_new(modelPath.utf8().get_data());
    if (!model) {
        UtilityFunctions::push_error("Vosk: failed to load model at " + modelPath);
        return;
    }
    recognizer = vosk_recognizer_new_grm(model, SAMPLE_RATE, wordsList.utf8().get_data());
    if (!recognizer) {
        UtilityFunctions::push_error("Vosk: failed to create GRM recognizer");
        vosk_model_free(model); model = nullptr;
    }
}

/**
 * @brief Update the recognizer's grammar/word list at runtime.
 *
 * @param wordsList New JSON grammar as expected by Vosk GRM APIs.
 */
void Vosk::set_wordlist(String wordsList)
{
    if (!recognizer) {
        UtilityFunctions::push_warning("Vosk.set_wordlist: recognizer is null (call init/init_wordlist first).");
        return;
    }
    vosk_recognizer_set_grm(recognizer, wordsList.utf8().get_data());
}

/**
 * @brief Accept raw waveform data (see header for expectations).
 *
 * @note Temporary conversion:
 * Godot often provides 32-bit float stereo; this block extracts bytes into
 * a 16-bit mono buffer to satisfy the Vosk recognizer.
 *
 * @warning The fixed-size buffer assumes a max chunk size; consider
 *         replacing with a dynamically sized buffer if you feed larger
 *         frames.
 */
bool Vosk::accept_wave_form(PackedByteArray data)
{
    if (!recognizer) return false;
    if (data.is_empty()) return false;

    // big hack waiting https://github.com/godotengine/godot-proposals/issues/7105
    char mono[TEMP_MONO_BUFFER_SIZE] = { 0 };

    for (int i = 0; i < data.size(); i += 4) {
        mono[i / 2 + 0] = data[i];
        mono[i / 2 + 1] = data[i + 1];
    }

    return vosk_recognizer_accept_waveform(
        recognizer,
        mono,
        data.size()/2
    );
}

/**
 * @brief Convert stereo float frames to 16-bit mono and feed to Vosk.
 *
 * @details Uses the left channel (x) after scaling/clamping to int16 range.
 * This is a pragmatic downmix suitable for many use cases.
 */
bool Vosk::accept_wave_form_stereo_float(PackedVector2Array data)
{
    if (!recognizer) return false;
    if (data.is_empty()) return false;
    
    std::vector<short> mono;
    mono.resize(data.size());

    for (int i = 0; i < data.size(); i ++) {
        mono[i] = std::clamp( (short) (data[i].x * PCM_SCALE), PCM_MIN, PCM_MAX);
    }

    return vosk_recognizer_accept_waveform_s(
        recognizer,
        mono.data(),
        data.size()
    );
}

/**
 * @brief Return interim JSON hypothesis (if any).
 * @return See Vosk docs for JSON schema; typically contains "partial".
 */
String Vosk::partial_result()
{
    return vosk_recognizer_partial_result(recognizer);
}

/**
 * @brief Return finalized JSON result when available.
 * @return See Vosk docs for JSON schema; typically contains "text" and "result".
 */
String Vosk::result()
{
    return vosk_recognizer_result(recognizer);
}