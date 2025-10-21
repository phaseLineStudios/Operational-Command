# TerrainEffects Class Reference

*File:* `scripts/sim/TerrainEffects.gd`
*Class name:* `TerrainEffects`
*Inherits:* `RefCounted`
> **Experimental**

## Synopsis

```gdscript
class_name TerrainEffects
extends RefCounted
```

## Brief

Compute terrain/weather multipliers for combat/spotting

Returns accuracy/damage/spotting multipliers and LOS state

LOS test + integral attenuation via TerrainRender surfaces if available.

## Public Member Functions

- [`func weather_severity_from_scenario(s: ScenarioData) -> float`](TerrainEffects/functions/weather_severity_from_scenario.md) — Derive 0..1 weather severity from ScenarioData (fog/rain).
- [`func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary`](TerrainEffects/functions/_brush_fields.md) — Brush field adapter for either TerrainRender or TerrainData (area features only).
- [`func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float`](TerrainEffects/functions/_try_field.md)
- [`func _get_h(terrain: TerrainData, p: Vector2) -> float`](TerrainEffects/functions/_get_h.md)
- [`func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2`](TerrainEffects/functions/_extract_pos.md)
- [`func _is_moving(x: ScenarioUnit) -> bool`](TerrainEffects/functions/_is_moving.md)
- [`func _is_dug_in(_x: ScenarioUnit) -> bool`](TerrainEffects/functions/_is_dug_in.md) — Reserved for future posture logic. **Experimental**

## Public Attributes

- `TerrainEffectsConfig cfg`
- `TerrainRender renderer`
- `TerrainData terrain`
- `ScenarioData scenario`
- `float dh`
- `float cover`
- `float conceal`
- `float conceal_scale`
- `float out_dmg`
- `float out_spot`
- `float step_m`
- `float h_line`
- `float per_m`

## Member Function Documentation

### weather_severity_from_scenario

```gdscript
func weather_severity_from_scenario(s: ScenarioData) -> float
```

Derive 0..1 weather severity from ScenarioData (fog/rain).

### _brush_fields

```gdscript
func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary
```

Brush field adapter for either TerrainRender or TerrainData (area features only).

### _try_field

```gdscript
func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float
```

### _get_h

```gdscript
func _get_h(terrain: TerrainData, p: Vector2) -> float
```

### _extract_pos

```gdscript
func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2
```

### _is_moving

```gdscript
func _is_moving(x: ScenarioUnit) -> bool
```

### _is_dug_in

```gdscript
func _is_dug_in(_x: ScenarioUnit) -> bool
```

> **Experimental**

Reserved for future posture logic.

## Member Data Documentation

### cfg

```gdscript
var cfg: TerrainEffectsConfig
```

### renderer

```gdscript
var renderer: TerrainRender
```

### terrain

```gdscript
var terrain: TerrainData
```

### scenario

```gdscript
var scenario: ScenarioData
```

### dh

```gdscript
var dh: float
```

### cover

```gdscript
var cover: float
```

### conceal

```gdscript
var conceal: float
```

### conceal_scale

```gdscript
var conceal_scale: float
```

### out_dmg

```gdscript
var out_dmg: float
```

### out_spot

```gdscript
var out_spot: float
```

### step_m

```gdscript
var step_m: float
```

### h_line

```gdscript
var h_line: float
```

### per_m

```gdscript
var per_m: float
```
