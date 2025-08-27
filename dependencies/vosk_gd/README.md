# vosk_gd
GDExtension allowing offline speech recognition within Godot.

## Methods
```c++
void init(String modelPath);
void init_wordlist(String modelPath, String wordsList);
bool accept_wave_form(PackedByteArray data);
bool accept_wave_form_stereo_float(PackedVector2Array data);
String partial_result();
String result();
```
*See `src/vosk_api.h` for more details on how to use these methods*

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
scons platform=<platform>
```

### Install
1. Copy (if not automatically copied) the resulting files to: `/src/addons/vosk_gd/`
2. Copy (if not automaitcally copied) the vosk binaries from: `bin/<platform>/` to: `/src/addons/vosk_gd/`

### Get Models
- Download a model from [Vosk](https://alphacephei.com/vosk/models), preferably "small" models as the largeo nes require crazy amounts of memory.
- Extract the model into `src/third_party/vosk/`
- In `STTService.gd` set the model path to reflect your model.

*Note: We should create a service to download the model on game start instead of packaging the applciation with it*