# SimWorld Class Reference

*File:* `scripts/sim/SimWorld.gd`
*Class name:* `SimWorld`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name SimWorld
extends Node
```

## Brief

Authoritative deterministic simulation loop.

## Detailed Description

Runs a fixed-step mission sim (INIT->RUNNING->PAUSED->COMPLETED):
process_orders -> update_movement -> update_los -> resolve_combat ->
update_morale -> emit_events -> record_replay. Provides read-only queries
and emits events via signals for UI/logging.

Fixed tick rate (Hz).

## Public Member Functions

- [`func _ready() -> void`](SimWorld/functions/_ready.md) — Initializes tick timing/RNG and wires router signals.
- [`func init_world(scenario: ScenarioData) -> void`](SimWorld/functions/init_world.md) — Initialize world from a scenario and build unit indices.
- [`func _process(dt: float) -> void`](SimWorld/functions/_process.md) — Fixed-rate loop; advances the sim in discrete ticks while RUNNING.
- [`func _step_tick(dt: float) -> void`](SimWorld/functions/_step_tick.md) — Executes a single sim tick (deterministic order).
- [`func _process_orders() -> void`](SimWorld/functions/_process_orders.md) — Pops ready orders and routes them via the OrdersRouter.
- [`func _update_movement(dt: float) -> void`](SimWorld/functions/_update_movement.md) — Advances movement for all sides and emits unit snapshots.
- [`func _update_los() -> void`](SimWorld/functions/_update_los.md) — Computes LOS contact pairs once per tick and emits contact events.
- [`func _resolve_combat() -> void`](SimWorld/functions/_resolve_combat.md) — Resolves combat for current contact pairs (range/logic inside controller).
- [`func _update_morale() -> void`](SimWorld/functions/_update_morale.md) — Updates morale (placeholder).
- [`func _emit_events() -> void`](SimWorld/functions/_emit_events.md) — Emits per-tick radio/log events (placeholder).
- [`func _record_replay() -> void`](SimWorld/functions/_record_replay.md) — Records a compact snapshot for replays.
- [`func queue_orders(orders: Array) -> int`](SimWorld/functions/queue_orders.md) — Enqueue structured orders parsed elsewhere.
- [`func bind_radio(radio: Radio, parser: Node) -> void`](SimWorld/functions/bind_radio.md) — Bind Radio and Parser so voice results are queued automatically.
- [`func pause() -> void`](SimWorld/functions/pause.md) — Pause simulation.
- [`func resume() -> void`](SimWorld/functions/resume.md) — Resume simulation.
- [`func step() -> void`](SimWorld/functions/step.md) — Step one tick while paused.
- [`func complete() -> void`](SimWorld/functions/complete.md) — Complete mission.
- [`func get_tick() -> int`](SimWorld/functions/get_tick.md) — Current tick index.
- [`func get_mission_time_s() -> float`](SimWorld/functions/get_mission_time_s.md) — Mission clock in seconds.
- [`func get_unit_snapshot(unit_id: String) -> Dictionary`](SimWorld/functions/get_unit_snapshot.md) — Shallow snapshot of a unit for UI.
- [`func get_unit_snapshots() -> Array[Dictionary]`](SimWorld/functions/get_unit_snapshots.md) — Snapshots of all units.
- [`func get_outcome_status() -> String`](SimWorld/functions/get_outcome_status.md) — Outcome status string.
- [`func set_rng_seed(new_rng_seed: int) -> void`](SimWorld/functions/set_rng_seed.md) — Set RNG seed (determinism).
- [`func get_rng_seed() -> int`](SimWorld/functions/get_rng_seed.md) — Get RNG seed.
- [`func _snapshot_unit(su: ScenarioUnit) -> Dictionary`](SimWorld/functions/_snapshot_unit.md) — Build a compact unit snapshot.
- [`func _transition(prev: State, next: State) -> void`](SimWorld/functions/_transition.md) — Apply a state transition and emit `signal mission_state_changed`.
- [`func get_unit_debug_path(uid: String) -> PackedVector2Array`](SimWorld/functions/get_unit_debug_path.md) — Planned path for a unit (for debug).
- [`func _on_order_applied(order: Dictionary) -> void`](SimWorld/functions/_on_order_applied.md) — Router callback: order applied.
- [`func _on_order_failed(_order: Dictionary, reason: String) -> void`](SimWorld/functions/_on_order_failed.md) — Router callback: order failed.

## Public Attributes

- `int rng_seed` — Initial RNG seed (0 -> randomize)
- `LOSAdapter los_adapter` — LOS helper/adapter.
- `MovementAdapter movement_adapter` — Movement adapter.
- `CombatController combat_controller` — Combat controller.
- `OrdersRouter _router` — Orders router.
- `State _state`
- `OrdersQueue _orders`
- `ScenarioData _scenario`
- `Dictionary _units_by_id`
- `Dictionary _units_by_callsign`
- `Dictionary _playable_by_callsign`
- `Array[ScenarioUnit] _friendlies`
- `Array[ScenarioUnit] _enemies`
- `Array[Dictionary] _replay`
- `PackedStringArray _last_contacts`

## Signals

- `signal unit_updated(unit_id: String, snapshot: Dictionary)` — Emitted when a unit snapshot changes.
- `signal contact_reported(attacker_id: String, defender_id: String)` — Emitted when LOS contact is reported (attacker->defender).
- `signal radio_message(level: String, text: String)` — Emitted for radio/log feedback.
- `signal mission_state_changed(prev: State, next: State)` — Emitted when mission state transitions.
- `signal engagement_reported(attacker_id: String, defender_id: String, damage: float)` — Emitted when damage > 0 is applied this tick (attacker->defender).

## Enumerations

- `enum State` — Simulation state machine.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initializes tick timing/RNG and wires router signals. Starts processing.

### init_world

```gdscript
func init_world(scenario: ScenarioData) -> void
```

Initialize world from a scenario and build unit indices.
`scenario` ScenarioData to load.

### _process

```gdscript
func _process(dt: float) -> void
```

Fixed-rate loop; advances the sim in discrete ticks while RUNNING.
`dt` Frame delta seconds.

### _step_tick

```gdscript
func _step_tick(dt: float) -> void
```

Executes a single sim tick (deterministic order).
`dt` Tick delta seconds.

### _process_orders

```gdscript
func _process_orders() -> void
```

Pops ready orders and routes them via the OrdersRouter.

### _update_movement

```gdscript
func _update_movement(dt: float) -> void
```

Advances movement for all sides and emits unit snapshots.

### _update_los

```gdscript
func _update_los() -> void
```

Computes LOS contact pairs once per tick and emits contact events.

### _resolve_combat

```gdscript
func _resolve_combat() -> void
```

Resolves combat for current contact pairs (range/logic inside controller).
Emits `signal engagement_reported` for damage > 0.

### _update_morale

```gdscript
func _update_morale() -> void
```

Updates morale (placeholder).

### _emit_events

```gdscript
func _emit_events() -> void
```

Emits per-tick radio/log events (placeholder).

### _record_replay

```gdscript
func _record_replay() -> void
```

Records a compact snapshot for replays.

### queue_orders

```gdscript
func queue_orders(orders: Array) -> int
```

Enqueue structured orders parsed elsewhere.
`orders` Array of order dictionaries.
[return] Number of orders accepted.

### bind_radio

```gdscript
func bind_radio(radio: Radio, parser: Node) -> void
```

Bind Radio and Parser so voice results are queued automatically.
`radio` Radio node emitting `radio_result`.
`parser` Parser node emitting `parsed(Array)` and `parse_error(String)`.

### pause

```gdscript
func pause() -> void
```

Pause simulation.

### resume

```gdscript
func resume() -> void
```

Resume simulation.

### step

```gdscript
func step() -> void
```

Step one tick while paused.

### complete

```gdscript
func complete() -> void
```

Complete mission.

### get_tick

```gdscript
func get_tick() -> int
```

Current tick index.
[return] Tick number.

### get_mission_time_s

```gdscript
func get_mission_time_s() -> float
```

Mission clock in seconds.
[return] Elapsed mission time.

### get_unit_snapshot

```gdscript
func get_unit_snapshot(unit_id: String) -> Dictionary
```

Shallow snapshot of a unit for UI.
`unit_id` ScenarioUnit id.
[return] Snapshot dictionary.

### get_unit_snapshots

```gdscript
func get_unit_snapshots() -> Array[Dictionary]
```

Snapshots of all units.
[return] Array of snapshot dictionaries.

### get_outcome_status

```gdscript
func get_outcome_status() -> String
```

Outcome status string.
[return] `"in_progress"` or `"completed"`.

### set_rng_seed

```gdscript
func set_rng_seed(new_rng_seed: int) -> void
```

Set RNG seed (determinism).
`new_rng_seed` Seed value.

### get_rng_seed

```gdscript
func get_rng_seed() -> int
```

Get RNG seed.
[return] Current RNG seed.

### _snapshot_unit

```gdscript
func _snapshot_unit(su: ScenarioUnit) -> Dictionary
```

Build a compact unit snapshot.
`su` ScenarioUnit instance (nullable).
[return] Snapshot dictionary or empty if null.

### _transition

```gdscript
func _transition(prev: State, next: State) -> void
```

Apply a state transition and emit `signal mission_state_changed`.
`prev` Previous state.
`next` Next state.

### get_unit_debug_path

```gdscript
func get_unit_debug_path(uid: String) -> PackedVector2Array
```

Planned path for a unit (for debug).
`uid` Unit id.
[return] PackedVector2Array of path points (meters).

### _on_order_applied

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

Router callback: order applied.
`order` Order dictionary.

### _on_order_failed

```gdscript
func _on_order_failed(_order: Dictionary, reason: String) -> void
```

Router callback: order failed.
`_order` Order dictionary (unused).
`reason` Failure reason.

## Member Data Documentation

### rng_seed

```gdscript
var rng_seed: int
```

Decorators: `@export`

Initial RNG seed (0 -> randomize)

### los_adapter

```gdscript
var los_adapter: LOSAdapter
```

Decorators: `@export`

LOS helper/adapter.

### movement_adapter

```gdscript
var movement_adapter: MovementAdapter
```

Decorators: `@export`

Movement adapter.

### combat_controller

```gdscript
var combat_controller: CombatController
```

Decorators: `@export`

Combat controller.

### _router

```gdscript
var _router: OrdersRouter
```

Decorators: `@export`

Orders router.

### _state

```gdscript
var _state: State
```

### _orders

```gdscript
var _orders: OrdersQueue
```

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _units_by_id

```gdscript
var _units_by_id: Dictionary
```

### _units_by_callsign

```gdscript
var _units_by_callsign: Dictionary
```

### _playable_by_callsign

```gdscript
var _playable_by_callsign: Dictionary
```

### _friendlies

```gdscript
var _friendlies: Array[ScenarioUnit]
```

### _enemies

```gdscript
var _enemies: Array[ScenarioUnit]
```

### _replay

```gdscript
var _replay: Array[Dictionary]
```

### _last_contacts

```gdscript
var _last_contacts: PackedStringArray
```

## Signal Documentation

### unit_updated

```gdscript
signal unit_updated(unit_id: String, snapshot: Dictionary)
```

Emitted when a unit snapshot changes.

### contact_reported

```gdscript
signal contact_reported(attacker_id: String, defender_id: String)
```

Emitted when LOS contact is reported (attacker->defender).

### radio_message

```gdscript
signal radio_message(level: String, text: String)
```

Emitted for radio/log feedback.

### mission_state_changed

```gdscript
signal mission_state_changed(prev: State, next: State)
```

Emitted when mission state transitions.

### engagement_reported

```gdscript
signal engagement_reported(attacker_id: String, defender_id: String, damage: float)
```

Emitted when damage > 0 is applied this tick (attacker->defender).

## Enumeration Type Documentation

### State

```gdscript
enum State
```

Simulation state machine.
