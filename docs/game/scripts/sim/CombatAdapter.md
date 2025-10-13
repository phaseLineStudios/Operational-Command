# CombatAdapter Class Reference

*File:* `scripts/sim/CombatAdapter.gd`
*Class name:* `CombatAdapter`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name CombatAdapter
extends Node
```

## Brief

Small adapter that gates firing on ammo and consumes on success.

## Detailed Description

Adds helpers to compute LOW/CRITICAL penalties (placeholders) without hard-coding
this into AmmoSystem or combat resolution.

## Public Member Functions

- [`func _ready() -> void`](CombatAdapter/functions/_ready.md) — Resolve the AmmoSystem reference when the node enters the tree.
- [`func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool`](CombatAdapter/functions/request_fire.md) — Request to fire: returns true if ammo was consumed; false if blocked.
- [`func get_ammo_penalty(unit_id: String, ammo_type: String) -> Dictionary`](CombatAdapter/functions/get_ammo_penalty.md) — Compute penalty multipliers given the unit and ammo_type *without* consuming.
- [`func request_fire_with_penalty(unit_id: String, ammo_type: String, rounds: int = 1) -> Dictionary`](CombatAdapter/functions/request_fire_with_penalty.md) — Request to fire *and* return penalty info for the caller to apply to accuracy/ROF/etc.

## Public Attributes

- `NodePath ammo_system_path` — NodePath to an AmmoSystem node in the scene.
- `AmmoSystem  ## Cached AmmoSystem reference _ammo`

## Signals

- `signal fire_blocked_empty(unit_id: String, ammo_type: String)` — Emitted when a unit attempts to fire but is out of the requested ammo type.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Resolve the AmmoSystem reference when the node enters the tree.

### request_fire

```gdscript
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool
```

Request to fire: returns true if ammo was consumed; false if blocked.
Fails open (true) when there is no ammo system or unit is unknown.

### get_ammo_penalty

```gdscript
func get_ammo_penalty(unit_id: String, ammo_type: String) -> Dictionary
```

Compute penalty multipliers given the unit and ammo_type *without* consuming.
States:
- "normal": no penalty
- "low":     ≤ u.ammunition_low_threshold (and > critical)
- "critical":≤ u.ammunition_critical_threshold (and > 0)
- "empty":   == 0 (weapon is hard-blocked elsewhere)

Returns a Dictionary:
{
state: "normal"|"low"|"critical"|"empty",
attack_power_mult: float,  # 1.0 normal, 0.8 low, 0.5 critical
attack_cycle_mult: float, # 1.0 normal, 1.25 low, 1.5 critical (use to scale cycle/cooldown)
suppression_mult:  float, # 1.0 normal, 0.75 low, 0.0 critical (disable area fire)
morale_delta:      int,   # 0 normal, -10 low, -20 critical (apply in morale system if desired)
ai_recommendation: String # "normal"|"conserve"|"defensive"|"avoid"
}

### request_fire_with_penalty

```gdscript
func request_fire_with_penalty(unit_id: String, ammo_type: String, rounds: int = 1) -> Dictionary
```

Request to fire *and* return penalty info for the caller to apply to accuracy/ROF/etc.
Example use in combat:
var r := _adapter.request_fire_with_penalty(attacker.id, "small_arms", 5)
if r.allow:
accuracy *= r.attack_power_mult
cycle_time *= r.attack_cycle_mult
suppression *= r.suppression_mult
# optionally apply r.morale_delta and heed r.ai_recommendation

## Member Data Documentation

### ammo_system_path

```gdscript
var ammo_system_path: NodePath
```

Decorators: `@export`

NodePath to an AmmoSystem node in the scene.

### _ammo

```gdscript
var _ammo: AmmoSystem  ## Cached AmmoSystem reference
```

## Signal Documentation

### fire_blocked_empty

```gdscript
signal fire_blocked_empty(unit_id: String, ammo_type: String)
```

Emitted when a unit attempts to fire but is out of the requested ammo type.
