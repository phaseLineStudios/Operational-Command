# PostProcessController Class Reference

*File:* `scripts/ui/PostProcessController.gd`
*Class name:* `PostProcessController`
*Inherits:* `CanvasLayer`

## Synopsis

```gdscript
class_name PostProcessController
extends CanvasLayer
```

## Brief

Controlls Post Process filters.

## Public Member Functions

- [`func _ready() -> void`](PostProcessController/functions/_ready.md)
- [`func _apply_settings() -> void`](PostProcessController/functions/_apply_settings.md) — apply parameters.
- [`func _get_shader(rect: CanvasItem) -> ShaderMaterial`](PostProcessController/functions/_get_shader.md) — Get shader material from CanvasItem.
- [`func _apply_read_mode(enabled: bool) -> void`](PostProcessController/functions/_apply_read_mode.md)
- [`func _save_video_state() -> void`](PostProcessController/functions/_save_video_state.md)
- [`func _apply_video_full_res() -> void`](PostProcessController/functions/_apply_video_full_res.md)
- [`func _restore_video_state() -> void`](PostProcessController/functions/_restore_video_state.md)

## Public Attributes

- `float glow_intensity` — Intensity of glow.
- `float glow_bloom` — Intensity of bloom.
- `float adjustment_brightness` — Scene Brightness.
- `float adjustment_contrast` — Scene Contrast.
- `float adjustment_saturation` — Scene Saturation.
- `Texture lut_texture` — Optional LUT.
- `float vignette_intensity` — Intensity of the vignette.
- `float vignette_softness` — Softness of the vignette.
- `float grain_amount` — Amount of grains in Film Grain PPEffect.
- `float grain_size` — Size of grains in Film Grain PPEffect.
- `float ca_intensity` — Intensity of Chromatic Abboration.
- `float sharpen_strength` — Strength of Sharpen/unsharpen mask.
- `bool read_mode_enabled` — Temporarily overrides post-processing/video settings to improve text readability.
- `bool read_mode_disable_film_grain` — Disable film grain while reading.
- `bool read_mode_disable_chromatic_aberration` — Disable chromatic aberration while reading.
- `bool read_mode_disable_vignette` — Disable vignette while reading.
- `bool read_mode_disable_glow` — Disable glow/bloom while reading.
- `float read_mode_sharpen_strength` — Sharpen strength override while reading (<= 0 keeps current).
- `bool read_mode_force_full_res` — If true, temporarily force full-resolution rendering while reading.
- `ShaderMaterial film_grain_shader`
- `ShaderMaterial general_shader`
- `Environment environment`
- `bool _read_mode_cached`
- `Dictionary _saved_settings`
- `Dictionary _saved_video`
- `bool _read_mode_enabled`
- `ColorRect general_rect`
- `ColorRect film_grain_rect`
- `WorldEnvironment world_environment`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _apply_settings

```gdscript
func _apply_settings() -> void
```

apply parameters.

### _get_shader

```gdscript
func _get_shader(rect: CanvasItem) -> ShaderMaterial
```

Get shader material from CanvasItem.

### _apply_read_mode

```gdscript
func _apply_read_mode(enabled: bool) -> void
```

### _save_video_state

```gdscript
func _save_video_state() -> void
```

### _apply_video_full_res

```gdscript
func _apply_video_full_res() -> void
```

### _restore_video_state

```gdscript
func _restore_video_state() -> void
```

## Member Data Documentation

### glow_intensity

```gdscript
var glow_intensity: float
```

Decorators: `@export`

Intensity of glow.

### glow_bloom

```gdscript
var glow_bloom: float
```

Decorators: `@export`

Intensity of bloom.

### adjustment_brightness

```gdscript
var adjustment_brightness: float
```

Decorators: `@export`

Scene Brightness.

### adjustment_contrast

```gdscript
var adjustment_contrast: float
```

Decorators: `@export`

Scene Contrast.

### adjustment_saturation

```gdscript
var adjustment_saturation: float
```

Decorators: `@export`

Scene Saturation.

### lut_texture

```gdscript
var lut_texture: Texture
```

Decorators: `@export`

Optional LUT.

### vignette_intensity

```gdscript
var vignette_intensity: float
```

Decorators: `@export_range(0.0, 2.0)`

Intensity of the vignette.

### vignette_softness

```gdscript
var vignette_softness: float
```

Decorators: `@export_range(0.0, 1.0)`

Softness of the vignette.

### grain_amount

```gdscript
var grain_amount: float
```

Decorators: `@export_range(0.0, 1.0)`

Amount of grains in Film Grain PPEffect.

### grain_size

```gdscript
var grain_size: float
```

Decorators: `@export_range(0.1, 10.0)`

Size of grains in Film Grain PPEffect.

### ca_intensity

```gdscript
var ca_intensity: float
```

Decorators: `@export_range(0.0, 5.0)`

Intensity of Chromatic Abboration.

### sharpen_strength

```gdscript
var sharpen_strength: float
```

Decorators: `@export_range(0.0, 3.0)`

Strength of Sharpen/unsharpen mask.

### read_mode_enabled

```gdscript
var read_mode_enabled: bool
```

Decorators: `@export`

Temporarily overrides post-processing/video settings to improve text readability.

### read_mode_disable_film_grain

```gdscript
var read_mode_disable_film_grain: bool
```

Decorators: `@export`

Disable film grain while reading.

### read_mode_disable_chromatic_aberration

```gdscript
var read_mode_disable_chromatic_aberration: bool
```

Decorators: `@export`

Disable chromatic aberration while reading.

### read_mode_disable_vignette

```gdscript
var read_mode_disable_vignette: bool
```

Decorators: `@export`

Disable vignette while reading.

### read_mode_disable_glow

```gdscript
var read_mode_disable_glow: bool
```

Decorators: `@export`

Disable glow/bloom while reading.

### read_mode_sharpen_strength

```gdscript
var read_mode_sharpen_strength: float
```

Decorators: `@export_range(0.0, 3.0)`

Sharpen strength override while reading (<= 0 keeps current).

### read_mode_force_full_res

```gdscript
var read_mode_force_full_res: bool
```

Decorators: `@export`

If true, temporarily force full-resolution rendering while reading.

### film_grain_shader

```gdscript
var film_grain_shader: ShaderMaterial
```

### general_shader

```gdscript
var general_shader: ShaderMaterial
```

### environment

```gdscript
var environment: Environment
```

### _read_mode_cached

```gdscript
var _read_mode_cached: bool
```

### _saved_settings

```gdscript
var _saved_settings: Dictionary
```

### _saved_video

```gdscript
var _saved_video: Dictionary
```

### _read_mode_enabled

```gdscript
var _read_mode_enabled: bool
```

### general_rect

```gdscript
var general_rect: ColorRect
```

### film_grain_rect

```gdscript
var film_grain_rect: ColorRect
```

### world_environment

```gdscript
var world_environment: WorldEnvironment
```
