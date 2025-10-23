# piper_gd
GDExtension that runs the Piper TTS CLI as a separate process for offline speech in Godot.

## Methods
```cpp
void set_piper_path(String path);
void set_voice(String model, String config);
bool is_ready() const;
bool synthesize_to_file(String text, String wav_path, Dictionary opts = {});
Ref<AudioStreamWAV> synthesize_to_stream(String text, Dictionary opts = {});
int64_t synthesize_to_stream_async(String text, Dictionary opts = {});
void wait();
signal synthesis_completed(int id, AudioStreamWAV stream);
signal synthesis_failed(int id, String message);
```
*See `src/piper_gd.h` for full signatures and comments.*

## Setup
### Prerequisits
- [SCons](https://scons.org/) 
- [Python3](https://www.python.org/)

### Build
[Docs](https://docs.godotengine.org/en/4.4/tutorials/scripting/gdextension/gdextension_cpp_example.html#doc-gdextension-cpp-example)
1. Initialize the submodule
```bash
cd godot-cpp
git submodule update --init
cd ..
```

2. Build the C++ bindings
```bash
godot --dump-extension-api
```
and compile them:
```bash
cd godot-cpp
scons platform=<platform> custom_api_file=<PATH_TO_FILE>
cd ..
```

3. Build the extension
```bash
scons platform=<platform> target=<editor, template_debug or template_release>
```

### Install
Copy the built library (if not already in place) into:
`src/addons/piper_gd/<platform-arch>/`

Place the Piper CLI binary and voices here:
```bash
src/third_party/piper/
  win64/piper.exe
  voices/<quality-locale>/<your-voice>/*.onnx
  voices/<quality-locale>/<your-voice>/*.onnx.json
```
*(Keep them as files, not packed into the PCK.)*

## License adherence
- The game never links to Piper code. We spawn an external process (Piper CLI), pass text in, receive audio out.
- This is mere aggregation: the game keeps its own license (e.g., CC BY-NC-SA 4.0), while Piper remains GPL-3.0.
- Compliance we follow in this repo:
  - Include GPL text for the exact Piper build under `src/third_party/piper/`.
  - Provide the corresponding source (link the exact commit/tag + build steps or include a source offer file).
  - Keep all notices intact.
- Voices carry their own licenses. We include those under `src/third_party/piper/voices/<quality-locale>/<voice>/`.

### Attribution
- Piper binary: built from `OHF-Voice/piper1-gpl` @ `387ca06`, method: `onefile`.
- Voices: `ryan`, license `MIT`.

## License
- piper_gd code (this extension): follow the repo’s main license (`CC BY-NC-SA 4.0`).
- Piper CLI binary: GPL-3.0.
- Voices: per-voice licenses.