# ScenarioUnit Class Reference

*File:* `scripts/editors/ScenarioUnit.gd`
*Class name:* `ScenarioUnit`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioUnit
extends Resource
```

## Brief

Start movement; will plan if needed or if dest is provided.

## Public Member Functions

- [`func bind_fuel_system(fs: FuelSystem) -> void`](ScenarioUnit/functions/bind_fuel_system.md) — Bind a FuelSystem instance at runtime.
- [`func plan_move(grid: PathGrid, dest_m: Vector2) -> bool`](ScenarioUnit/functions/plan_move.md) — Plan a path from current position to dest_m using PathGrid.
- [`func pause_move() -> void`](ScenarioUnit/functions/pause_move.md) — Pause.
- [`func resume_move() -> void`](ScenarioUnit/functions/resume_move.md) — Resume.
- [`func cancel_move() -> void`](ScenarioUnit/functions/cancel_move.md) — Cancel ongoing movement.
- [`func tick(dt: float, grid: PathGrid) -> void`](ScenarioUnit/functions/tick.md) — Advance movement by dt seconds on PathGrid (virtual position only).
- [`func estimate_eta_s(grid: PathGrid) -> float`](ScenarioUnit/functions/estimate_eta_s.md) — Estimate remaining time using grid weights (cheap mid-segment sampling).
- [`func move_state() -> MoveState`](ScenarioUnit/functions/move_state.md) — Query helpers (for UI/AI).
- [`func destination_m() -> Vector2`](ScenarioUnit/functions/destination_m.md)
- [`func current_path() -> PackedVector2Array`](ScenarioUnit/functions/current_path.md)
- [`func path_index() -> int`](ScenarioUnit/functions/path_index.md)
- [`func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float`](ScenarioUnit/functions/_speed_here_mps.md) — Terrain-modified speed at a point using PathGrid weight.
- [`func _estimate_time_along(grid: PathGrid, pts: PackedVector2Array) -> float`](ScenarioUnit/functions/_estimate_time_along.md) — Sum time for a polyline using mid-segment speed.
- [`func _kph_to_mps(speed_kph: float) -> float`](ScenarioUnit/functions/_kph_to_mps.md) — Convert kph to mps
- [`func serialize() -> Dictionary`](ScenarioUnit/functions/serialize.md) — Serialize to JSON.
- [`func deserialize(d: Dictionary) -> ScenarioUnit`](ScenarioUnit/functions/deserialize.md) — Deserialzie from JSON.

## Public Attributes

- `String id` — Unique identifier
- `String callsign` — Callsign
- `UnitData unit` — Unit Data
- `Vector2 position_m` — Unit Position
- `Affiliation affiliation` — Unit Affiliation
- `CombatMode combat_mode` — Unit Combat Mode
- `Behaviour behaviour` — Unit Behaviour
- `bool playable` — Is unit playable.
- `MoveState _move_state`
- `Vector2 _move_dest_m`
- `PackedVector2Array _move_path`
- `FuelSystem _fuel` — FuelSystem
FuelSystem provider used to scale speed at LOW/CRITICAL and 0 at EMPTY.

## Signals

- `signal move_planned(dest_m: Vector2, eta_s: float)` — Emitted when a path is planned
- `signal move_started(dest_m: Vector2)` — Emitted when movement begins
- `signal move_progress(pos_m: Vector2, eta_s: float)` — Emitted every tick while moving
- `signal move_arrived(dest_m: Vector2)` — Emitted on successful arrival
- `signal move_blocked(reason: String)` — Emitted when movement cannot proceed
- `signal move_paused` — Emitted when paused
- `signal move_resumed` — Emitted when resumed

## Enumerations

- `enum CombatMode` — Unit Rules of Engagement
- `enum Behaviour` — Unit movement behaviour
- `enum Affiliation` — Unit affiliation
- `enum MoveState` — Runtime movement states.

## Member Function Documentation

### bind_fuel_system

```gdscript
func bind_fuel_system(fs: FuelSystem) -> void
```

Bind a FuelSystem instance at runtime.

### plan_move

```gdscript
func plan_move(grid: PathGrid, dest_m: Vector2) -> bool
```

Plan a path from current position to dest_m using PathGrid.

### pause_move

```gdscript
func pause_move() -> void
```

Pause.

### resume_move

```gdscript
func resume_move() -> void
```

Resume.

### cancel_move

```gdscript
func cancel_move() -> void
```

Cancel ongoing movement.

### tick

```gdscript
func tick(dt: float, grid: PathGrid) -> void
```

Advance movement by dt seconds on PathGrid (virtual position only).

### estimate_eta_s

```gdscript
func estimate_eta_s(grid: PathGrid) -> float
```

Estimate remaining time using grid weights (cheap mid-segment sampling).

### move_state

```gdscript
func move_state() -> MoveState
```

Query helpers (for UI/AI).

### destination_m

```gdscript
func destination_m() -> Vector2
```

### current_path

```gdscript
func current_path() -> PackedVector2Array
```

### path_index

```gdscript
func path_index() -> int
```

### _speed_here_mps

```gdscript
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float
```

Terrain-modified speed at a point using PathGrid weight.
_speed_here_mps also includes speed penalties for low fuel

### _estimate_time_along

```gdscript
func _estimate_time_along(grid: PathGrid, pts: PackedVector2Array) -> float
```

Sum time for a polyline using mid-segment speed.

### _kph_to_mps

```gdscript
func _kph_to_mps(speed_kph: float) -> float
```

Convert kph to mps

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize to JSON.

### deserialize

```gdscript
func deserialize(d: Dictionary) -> ScenarioUnit
```

Deserialzie from JSON.

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique identifier

### callsign

```gdscript
var callsign: String
```

Decorators: `@export`

Callsign

### unit

```gdscript
var unit: UnitData
```

Decorators: `@export`

Unit Data

### position_m

```gdscript
var position_m: Vector2
```

Decorators: `@export`

Unit Position

### affiliation

```gdscript
var affiliation: Affiliation
```

Decorators: `@export`

Unit Affiliation

### combat_mode

```gdscript
var combat_mode: CombatMode
```

Decorators: `@export`

Unit Combat Mode

### behaviour

```gdscript
var behaviour: Behaviour
```

Decorators: `@export`

Unit Behaviour

### playable

```gdscript
var playable: bool
```

Decorators: `@export`

Is unit playable.

### _move_state

```gdscript
var _move_state: MoveState
```

### _move_dest_m

```gdscript
var _move_dest_m: Vector2
```

### _move_path

```gdscript
var _move_path: PackedVector2Array
```

### _fuel

```gdscript
var _fuel: FuelSystem
```

FuelSystem
FuelSystem provider used to scale speed at LOW/CRITICAL and 0 at EMPTY.

## Signal Documentation

### move_planned

```gdscript
signal move_planned(dest_m: Vector2, eta_s: float)
```

Emitted when a path is planned

### move_started

```gdscript
signal move_started(dest_m: Vector2)
```

Emitted when movement begins

### move_progress

```gdscript
signal move_progress(pos_m: Vector2, eta_s: float)
```

Emitted every tick while moving

### move_arrived

```gdscript
signal move_arrived(dest_m: Vector2)
```

Emitted on successful arrival

### move_blocked

```gdscript
signal move_blocked(reason: String)
```

Emitted when movement cannot proceed

### move_paused

```gdscript
signal move_paused
```

Emitted when paused

### move_resumed

```gdscript
signal move_resumed
```

Emitted when resumed

## Enumeration Type Documentation

### CombatMode

```gdscript
enum CombatMode
```

Unit Rules of Engagement

### Behaviour

```gdscript
enum Behaviour
```

Unit movement behaviour

### Affiliation

```gdscript
enum Affiliation
```

Unit affiliation

### MoveState

```gdscript
enum MoveState
```

Runtime movement states.
