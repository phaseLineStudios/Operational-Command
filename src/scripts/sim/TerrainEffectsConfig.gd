class_name TerrainEffectsConfig
extends Resource
## Tunables for terrain & environment modifiers.
## @experimental

## Elevation: accuracy *= 1 + k_elev_acc_per_m * clamp(Δh, -elev_cap_m, +elev_cap_m)
@export var k_elev_acc_per_m: float = 0.01
## Max height delta counted (meters)
@export var elev_cap_m: float = 30.0

## Cover reduces damage: damage *= (1 - cover * cover_damage_scale)
@export_range(0.0, 2.0, 0.01) var cover_damage_scale: float = 1.0

## Concealment scales with range: factor = (range / conceal_full_effect_range_m) clamped to [0..1]
@export_range(10.0, 2000.0, 5.0) var conceal_full_effect_range_m: float = 300.0

## LOS ray sample spacing (meters)
@export_range(1.0, 50.0, 1.0) var los_raycast_step_m: float = 5.0
## Eye/target heights above ground (meters)
@export var los_attacker_eye_h_m: float = 1.6
@export var los_target_h_m: float = 1.2

## Worst-case weather penalty: accuracy *= (1 - weather_severity * penalty)
@export_range(0.0, 1.0, 0.01) var weather_acc_penalty_at_severity1: float = 0.4

## Attacker moving penalty (accuracy)
@export_range(0.0, 1.0, 0.01) var moving_fire_penalty: float = 0.2
## Defender dug-in bonus (extra cover applied to damage)
@export_range(0.0, 1.0, 0.01) var dug_in_cover_bonus: float = 0.15

## Floors to avoid zeroing out
@export_range(0.01, 1.0, 0.01) var min_accuracy: float = 0.1
@export_range(0.01, 1.0, 0.01) var min_damage: float = 0.1

## Verbose logging
@export var debug: bool = false
