# TerrainEffectsConfig Class Reference

*File:* `scripts/sim/TerrainEffectsConfig.gd`
*Class name:* `TerrainEffectsConfig`
*Inherits:* `Resource`
> **Experimental**

## Synopsis

```gdscript
class_name TerrainEffectsConfig
extends Resource
```

## Brief

Tunables for terrain & environment modifiers.

## Public Attributes

- `float k_elev_acc_per_m` — Elevation: accuracy *= 1 + k_elev_acc_per_m * clamp(Δh, -elev_cap_m, +elev_cap_m)
- `float elev_cap_m` — Max height delta counted (meters)
- `float cover_damage_scale` — Cover reduces damage: damage *= (1 - cover * cover_damage_scale)
- `float conceal_full_effect_range_m` — Concealment scales with range: factor = (range / conceal_full_effect_range_m) clamped to [0..1]
- `float los_raycast_step_m` — LOS ray sample spacing (meters)
- `float los_attacker_eye_h_m` — Eye/target heights above ground (meters)
- `float los_target_h_m`
- `float weather_acc_penalty_at_severity1` — Worst-case weather penalty: accuracy *= (1 - weather_severity * penalty)
- `float moving_fire_penalty` — Attacker moving penalty (accuracy)
- `float dug_in_cover_bonus` — Defender dug-in bonus (extra cover applied to damage)
- `float min_accuracy` — Floors to avoid zeroing out
- `float min_damage`
- `bool debug` — Verbose logging

## Member Data Documentation

### k_elev_acc_per_m

```gdscript
var k_elev_acc_per_m: float
```

Elevation: accuracy *= 1 + k_elev_acc_per_m * clamp(Δh, -elev_cap_m, +elev_cap_m)

### elev_cap_m

```gdscript
var elev_cap_m: float
```

Max height delta counted (meters)

### cover_damage_scale

```gdscript
var cover_damage_scale: float
```

Cover reduces damage: damage *= (1 - cover * cover_damage_scale)

### conceal_full_effect_range_m

```gdscript
var conceal_full_effect_range_m: float
```

Concealment scales with range: factor = (range / conceal_full_effect_range_m) clamped to [0..1]

### los_raycast_step_m

```gdscript
var los_raycast_step_m: float
```

LOS ray sample spacing (meters)

### los_attacker_eye_h_m

```gdscript
var los_attacker_eye_h_m: float
```

Eye/target heights above ground (meters)

### los_target_h_m

```gdscript
var los_target_h_m: float
```

### weather_acc_penalty_at_severity1

```gdscript
var weather_acc_penalty_at_severity1: float
```

Worst-case weather penalty: accuracy *= (1 - weather_severity * penalty)

### moving_fire_penalty

```gdscript
var moving_fire_penalty: float
```

Attacker moving penalty (accuracy)

### dug_in_cover_bonus

```gdscript
var dug_in_cover_bonus: float
```

Defender dug-in bonus (extra cover applied to damage)

### min_accuracy

```gdscript
var min_accuracy: float
```

Floors to avoid zeroing out

### min_damage

```gdscript
var min_damage: float
```

### debug

```gdscript
var debug: bool
```

Verbose logging
