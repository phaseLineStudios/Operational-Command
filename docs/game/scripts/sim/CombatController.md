# CombatController Class Reference

*File:* `scripts/sim/Combat.gd`
*Class name:* `CombatController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name CombatController
extends Node
```

## Brief

Combat resolution for direct/indirect engagements.

## Detailed Description

Applies firepower, defense, morale, terrain, elevation, surprise, and posture
to produce losses, suppression, retreats, or destruction.

Debug sample rate (Hz) while scene runs

Also print compact line to console

Debug - build and emit a snapshot (for overlays/logging)

## Public Member Functions

- [`func _ready() -> void`](CombatController/functions/_ready.md) — Init
- [`func _make_su(u: UnitData, cs: String, pos: Variant) -> ScenarioUnit`](CombatController/functions/_make_su.md) — Minimal factory for a ScenarioUnit used by this controller (test harness)
- [`func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void`](CombatController/functions/combat_loop.md) — Loop triggered every turn to simulate unit behavior in combat
- [`func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> float`](CombatController/functions/calculate_damage.md) — Combat damage calculation with terrain/environment multipliers + ammo
- [`func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void`](CombatController/functions/check_abort_condition.md) — Check the various conditions for if the combat is finished
- [`func print_unit_status(attacker: UnitData, defender: UnitData) -> void`](CombatController/functions/print_unit_status.md) — check unit mid combat status for testing of combat status
- [`func _gate_and_consume(attacker: UnitData, ammo_type: String, rounds: int) -> Dictionary`](CombatController/functions/_gate_and_consume.md) — Gate a fire attempt by ammunition and consume rounds when allowed.
- [`func _apply_casualties(u: UnitData, raw_losses: int) -> int`](CombatController/functions/_apply_casualties.md) — Apply casualties to runtime state.
- [`func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool`](CombatController/functions/_within_engagement_envelope.md) — True if attacker is permitted to fire at defender at distance 'dist_m'.
- [`func _set_debug_rate() -> void`](CombatController/functions/_set_debug_rate.md) — Adjust debug timer
- [`func set_debug_enabled(v: bool) -> void`](CombatController/functions/set_debug_enabled.md) — Toggle debug at runtime

## Public Attributes

- `ScenarioData scenario` — Current Scenario reference
- `TerrainRender terrain_renderer` — Terrain renderer reference
- `TerrainEffectsConfig terrain_config` — TerrainEffectConfig reference
- `Control debug_overlay` — Optional Control that implements `update_debug(data: Dictionary)`
- `NodePath combat_adapter_path` — Ammo
- `UnitData imported_attacker` — imported units manually for testing purposes
- `UnitData imported_defender`
- `ScenarioUnit attacker_su`
- `ScenarioUnit defender_su`
- `CombatAdapter _adapter`
- `Dictionary _rof_cooldown` — Per-unit ROF cooldown (seconds since epoch when the next shot is allowed)
- `ScenarioUnit _cur_att`
- `ScenarioUnit _cur_def`
- `Timer _debug_timer`
- `float atk_str`
- `float def_str`
- `Variant c`

## Signals

- `signal notify_health` — for processing of possible combat outcomes
- `signal unit_destroyed`
- `signal unit_retreated`
- `signal unit_surrendered`
- `signal debug_updated(data: Dictionary)` — Emitted whenever a debug snapshot is produced

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Init

### _make_su

```gdscript
func _make_su(u: UnitData, cs: String, pos: Variant) -> ScenarioUnit
```

Minimal factory for a ScenarioUnit used by this controller (test harness)

### combat_loop

```gdscript
func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void
```

Loop triggered every turn to simulate unit behavior in combat

### calculate_damage

```gdscript
func calculate_damage(attacker: ScenarioUnit, defender: ScenarioUnit) -> float
```

Combat damage calculation with terrain/environment multipliers + ammo
gating/penalties + ROF cooldown

### check_abort_condition

```gdscript
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void
```

Check the various conditions for if the combat is finished

### print_unit_status

```gdscript
func print_unit_status(attacker: UnitData, defender: UnitData) -> void
```

check unit mid combat status for testing of combat status

### _gate_and_consume

```gdscript
func _gate_and_consume(attacker: UnitData, ammo_type: String, rounds: int) -> Dictionary
```

Gate a fire attempt by ammunition and consume rounds when allowed.

Returns a Dictionary with at least:
{ allow: bool, state: String, attack_power_mult: float,
attack_cycle_mult: float, suppression_mult: float, morale_delta: int,
ai_recommendation: String }

Behavior:
- If `_adapter` is null → allow=true with neutral multipliers (keeps tests running).
- If `CombatAdapter.request_fire_with_penalty()` exists → use it.
- Else fall back to `request_fire()` and map to a neutral response.

### _apply_casualties

```gdscript
func _apply_casualties(u: UnitData, raw_losses: int) -> int
```

Apply casualties to runtime state. Returns actual KIA + WIA applied

### _within_engagement_envelope

```gdscript
func _within_engagement_envelope(attacker: ScenarioUnit, dist_m: float) -> bool
```

True if attacker is permitted to fire at defender at distance 'dist_m'.

### _set_debug_rate

```gdscript
func _set_debug_rate() -> void
```

Adjust debug timer

### set_debug_enabled

```gdscript
func set_debug_enabled(v: bool) -> void
```

Toggle debug at runtime

## Member Data Documentation

### scenario

```gdscript
var scenario: ScenarioData
```

Decorators: `@export`

Current Scenario reference

### terrain_renderer

```gdscript
var terrain_renderer: TerrainRender
```

Decorators: `@export`

Terrain renderer reference

### terrain_config

```gdscript
var terrain_config: TerrainEffectsConfig
```

Decorators: `@export`

TerrainEffectConfig reference

### debug_overlay

```gdscript
var debug_overlay: Control
```

Decorators: `@export`

Optional Control that implements `update_debug(data: Dictionary)`

### combat_adapter_path

```gdscript
var combat_adapter_path: NodePath
```

Decorators: `@export`

Ammo

### imported_attacker

```gdscript
var imported_attacker: UnitData
```

imported units manually for testing purposes

### imported_defender

```gdscript
var imported_defender: UnitData
```

### attacker_su

```gdscript
var attacker_su: ScenarioUnit
```

### defender_su

```gdscript
var defender_su: ScenarioUnit
```

### _adapter

```gdscript
var _adapter: CombatAdapter
```

### _rof_cooldown

```gdscript
var _rof_cooldown: Dictionary
```

Per-unit ROF cooldown (seconds since epoch when the next shot is allowed)

### _cur_att

```gdscript
var _cur_att: ScenarioUnit
```

### _cur_def

```gdscript
var _cur_def: ScenarioUnit
```

### _debug_timer

```gdscript
var _debug_timer: Timer
```

### atk_str

```gdscript
var atk_str: float
```

### def_str

```gdscript
var def_str: float
```

### c

```gdscript
var c: Variant
```

## Signal Documentation

### notify_health

```gdscript
signal notify_health
```

for processing of possible combat outcomes

### unit_destroyed

```gdscript
signal unit_destroyed
```

### unit_retreated

```gdscript
signal unit_retreated
```

### unit_surrendered

```gdscript
signal unit_surrendered
```

### debug_updated

```gdscript
signal debug_updated(data: Dictionary)
```

Emitted whenever a debug snapshot is produced
