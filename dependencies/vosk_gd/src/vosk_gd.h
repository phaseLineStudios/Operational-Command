/**
 * @file vosk_gd.h
 * @author Eirik "Tapawingo"
 * 
 * @brief Godot 4.4 GDExtension binding for the Vosk speech recognition engine.
 *
 * This header declares the `godot::Vosk` node which exposes a minimal set of
 * Vosk API calls to GDScript/C# for real-time speech recognition.
 *
 * @see https://alphacephei.com/vosk/
 */

#ifndef VOSK_GD_H
#define VOSK_GD_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/variant.hpp>
#include <godot_cpp/variant/typed_array.hpp>

#include "vosk_api.h"

namespace godot {

/**
 * @class Vosk
 * @brief Godot Node wrapper around a VoskModel and VoskRecognizer.
 *
 * This node provides simple speech recognition methods that can be called
 * directly from Godot (GDScript). It owns and manages the lifetime of the
 * underlying `VoskModel` and `VoskRecognizer`.
 */
class Vosk : public Node {
    GDCLASS(Vosk, Node)

private:
    /**
     * @brief Unused tick accumulator (reserved for potential future use).
     * @details Currently not used by the implementation.
     */
    double time_passed;

    /**
     * @brief Reserved pointer for future extension or custom integration.
     * @details Not used in the current implementation.
     */
    void *vosk_handle;

    /**
     * @brief Pointer to the active Vosk recognizer instance.
     * @note Created by init or init_wordlist, freed in the destructor.
     */
    VoskRecognizer* recognizer;

    /**
     * @brief Pointer to the loaded Vosk acoustic/language model.
     * @note Created by init or init_wordlist, freed in the destructor.
     */
    VoskModel* model;

protected:
    /**
     * @brief Registers methods and properties with the Godot ClassDB.
     * @internal Called by Godot during class initialization.
     */
    static void _bind_methods();

public:
    /**
     * @brief Constructs an empty Vosk node.
     *
     * Call init or init_wordlist before feeding audio.
     */
    Vosk();

    /**
     * @brief Destructor. Frees recognizer and model if allocated.
     */
    ~Vosk();

    /**
     * @brief Initialize Vosk with a full ASR model.
     *
     * @param modelPath Filesystem path to a Vosk model directory. Example: `"res://models/vosk-model-small-en-us-0.15"`.
     */
    void init(String modelPath);

    /**
     * @brief Initialize Vosk with a grammar/wordlist constraint.
     *
     * Uses `vosk_recognizer_new_grm` to constrain decoding to the provided JSON grammar/word list (per Vosk API).
     *
     * @param modelPath Filesystem path to a Vosk model directory.
     * @param wordsList JSON grammar/word-list string accepted by Vosk.
     * @see https://alphacephei.com/vosk/ for grammar format details.
     */
    void init_wordlist(String modelPath, String wordsList);

    /**
     * @brief Update the recognizer's grammar/word list at runtime.
     *
     * This calls `vosk_recognizer_set_grm` to change the active grammar
     * without recreating the recognizer.
     *
     * @param wordsList New JSON grammar/word-list string.
     * @see https://alphacephei.com/vosk/ for grammar format details.
     */
    void set_wordlist(String wordsList);

    /**
     * @brief Feed raw mono 16-bit PCM audio (little-endian) to the recognizer.
     *
     * The input buffer is expected to contain interleaved 32-bit float stereo
     * frames as produced by some Godot pipelines; the implementation currently
     * downmixes/extracts to 16-bit mono using a temporary buffer (see source for details).
     *
     * @param data Packed byte array containing PCM data.
     * @return `true` if a final result is ready (result), `false` otherwise (check partial_result).
     *
     * @note This function contains a temporary "hack" to handle Godot data layout.
     *       See the implementation notes in `vosk_gd.cpp`.
     */
    bool accept_wave_form(PackedByteArray data);

    /**
     * @brief Feed stereo floating-point samples as PackedVector2Array.
     *
     * Each `Vector2` is treated as a stereo frame (x = left, y = right),
     * and downmixed to a single 16-bit mono sample using the left channel.
     *
     * @param data PackedVector2Array of stereo frames in the range [-1.0, 1.0].
     * @return `true` if a final result is ready (result), `false` otherwise.
     *
     * @note Internally converts to signed 16-bit and calls Vosk's `vosk_recognizer_accept_waveform_s`.
     */
    bool accept_wave_form_stereo_float(PackedVector2Array data);

    /**
     * @brief Retrieve the current partial recognition result as a JSON string.
     *
     * @return A JSON object string (see Vosk docs) with a `"partial"` field,
     *         or an empty result if no hypothesis is available.
     */
    String partial_result();

    /**
     * @brief Retrieve a finalized recognition result as a JSON string.
     *
     * Call this after accept_wave_form returns `true`, or periodically
     * during streaming to pull finalized segments.
     *
     * @return A JSON object string with fields like `"text"` and `"result"`,
     *         depending on Vosk configuration/model.
     */
	String result();

};

} // namespace godot

#endif // VOSK_GD_H