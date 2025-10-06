# SimWorld Class Reference

*File:* `scripts/sim/SimWorld.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Authoritative battlefield simulation (state, movement, combat, LOS).

## Detailed Description

Holds all unit entities and resolves ticks deterministically. Integrates
visibility LOS.gd and combat Combat.gd and
exposes read-only views for UI.

Ammo integration:
- Owns a mission-scoped `AmmoSystem` child.
- Feeds delta-time via `_physics_process`.
- Provides `on_unit_position(...)` for movement code to push positions.
- (Optionally) binds `RadioFeedback` to ammo events.

## Public Member Functions

- [`func _ready() -> void`](SimWorld/functions/_ready.md) — Create and configure AmmoSystem; optionally hook up RadioFeedback.
- [`func _physics_process(delta: float) -> void`](SimWorld/functions/_physics_process.md) — Drive AmmoSystem every frame so in-field resupply progresses over time.
- [`func on_unit_position(uid: String, pos: Vector3) -> void`](SimWorld/functions/on_unit_position.md) — Movement hook: call from movement/controller code whenever a unit moves.

## Public Attributes

- `AmmoSystem _ammo` — Central mission-scoped AmmoSystem instance.
- `CombatAdapter _adapter`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Create and configure AmmoSystem; optionally hook up RadioFeedback.

### _physics_process

```gdscript
func _physics_process(delta: float) -> void
```

Drive AmmoSystem every frame so in-field resupply progresses over time.

### on_unit_position

```gdscript
func on_unit_position(uid: String, pos: Vector3) -> void
```

Movement hook: call from movement/controller code whenever a unit moves.
`pos` is world-space (meters). For 2D maps, use Vector3(x, 0, y).

## Member Data Documentation

### _ammo

```gdscript
var _ammo: AmmoSystem
```

Central mission-scoped AmmoSystem instance. Created at runtime here.

### _adapter

```gdscript
var _adapter: CombatAdapter
```
