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
- `ShaderMaterial film_grain_shader`
- `ShaderMaterial general_shader`
- `Environment environment`
- `ColorRect film_grain_rect`
- `ColorRect general_rect`
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

### film_grain_rect

```gdscript
var film_grain_rect: ColorRect
```

### general_rect

```gdscript
var general_rect: ColorRect
```

### world_environment

```gdscript
var world_environment: WorldEnvironment
```
