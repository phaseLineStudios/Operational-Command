# AmmoSystem Class Reference

*File:* `scripts/sim/systems/AmmoSystem.gd`
*Class name:* `AmmoSystem`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name AmmoSystem
extends Node
```

## Brief

Centralized ammunition logistics for all units in a mission.

## Detailed Description

Responsibilities:
- Track per-unit ammo state (caps + current) and thresholds.
- Consume ammo on fire; emit low/critical/empty signals.
- In-field resupply: logistics units within radius transfer rounds over time
using their transfer rate; emits resupply started/completed.

## Public Member Functions

- [`func _ready() -> void`](AmmoSystem/functions/_ready.md) — Add to a group for convenient lookups.
- [`func register_unit(su: ScenarioUnit) -> void`](AmmoSystem/functions/register_unit.md) — Register a unit so AmmoSystem tracks it and applies defaults if missing.
- [`func unregister_unit(unit_id: String) -> void`](AmmoSystem/functions/unregister_unit.md) — Stop tracking a unit and tear down any active resupply links.
- [`func set_unit_position(unit_id: String, pos: Vector3) -> void`](AmmoSystem/functions/set_unit_position.md) — Update a unit's world-space position (meters; XZ used, Y ignored).
- [`func get_unit(unit_id: String) -> ScenarioUnit`](AmmoSystem/functions/get_unit.md) — Retrieve the ScenarioUnit previously registered (or null if unknown).
- [`func is_low(su: ScenarioUnit, t: String) -> bool`](AmmoSystem/functions/is_low.md) — True if current/cap <= low threshold (and > 0).
- [`func is_critical(su: ScenarioUnit, t: String) -> bool`](AmmoSystem/functions/is_critical.md) — True if current/cap <= critical threshold (and > 0).
- [`func is_empty(su: ScenarioUnit, t: String) -> bool`](AmmoSystem/functions/is_empty.md) — True if current ammo is zero.
- [`func consume(unit_id: String, t: String, amount: int = 1) -> bool`](AmmoSystem/functions/consume.md) — Decrease ammo for `unit_id` of type `t` by `amount`.
- [`func tick(delta: float) -> void`](AmmoSystem/functions/tick.md) — Start links for needy units and transfer rounds along active links.
- [`func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool`](AmmoSystem/functions/_within_radius.md) — True if src is within its transfer radius of dst.
- [`func _is_logistics(su: ScenarioUnit) -> bool`](AmmoSystem/functions/_is_logistics.md) — True if the unit should act as a logistics source.
- [`func _needs_ammo(su: ScenarioUnit) -> bool`](AmmoSystem/functions/_needs_ammo.md) — True if any ammo type is below its cap, unit is alive, and is stationary.
- [`func _has_stock(su: ScenarioUnit) -> bool`](AmmoSystem/functions/_has_stock.md) — True if unit has any stock left to transfer.
- [`func _pick_link_for(dst: ScenarioUnit) -> String`](AmmoSystem/functions/_pick_link_for.md) — Pick a logistics source within radius that has stock (simple first-match).
- [`func _begin_link(src_id: String, dst_id: String) -> void`](AmmoSystem/functions/_begin_link.md) — Begin a resupply link from `src_id` to `dst_id`.
- [`func _finish_link(dst_id: String) -> void`](AmmoSystem/functions/_finish_link.md) — Finish an active resupply link for `dst_id`.
- [`func _transfer_tick(delta: float) -> void`](AmmoSystem/functions/_transfer_tick.md) — Transfer rounds for all active links using a fractional-rate accumulator so
low rates still work at high frame rates (e.g., 20 rps @ 60 FPS).
- [`func _init_ammunition_from_equipment(su: ScenarioUnit) -> void`](AmmoSystem/functions/_init_ammunition_from_equipment.md) — Initialize ammunition capacities from equipment.

## Public Attributes

- `AmmoProfile ammo_profile` — Default caps/thresholds applied to newly registered units if missing.
- `Dictionary _units`
- `Dictionary _positions`
- `Dictionary _logi`
- `Dictionary _active_links`
- `Dictionary _xfer_accum`

## Signals

- `signal ammo_low(unit_id: String)` — Emitted when current/cap <= low threshold.
- `signal ammo_critical(unit_id: String)` — Emitted when current/cap <= critical threshold.
- `signal ammo_empty(unit_id: String)` — Emitted when current ammo hits zero.
- `signal resupply_started(src_unit_id: String, dst_unit_id: String)` — Emitted when a logistics unit begins resupplying a recipient.
- `signal resupply_completed(src_unit_id: String, dst_unit_id: String)` — Emitted when resupply finishes (recipient full OR stock exhausted).
- `signal supplier_exhausted(src_unit_id: String)` — Emitted when supplier runs out of ammunition stock.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Add to a group for convenient lookups.

### register_unit

```gdscript
func register_unit(su: ScenarioUnit) -> void
```

Register a unit so AmmoSystem tracks it and applies defaults if missing.

### unregister_unit

```gdscript
func unregister_unit(unit_id: String) -> void
```

Stop tracking a unit and tear down any active resupply links.

### set_unit_position

```gdscript
func set_unit_position(unit_id: String, pos: Vector3) -> void
```

Update a unit's world-space position (meters; XZ used, Y ignored).

### get_unit

```gdscript
func get_unit(unit_id: String) -> ScenarioUnit
```

Retrieve the ScenarioUnit previously registered (or null if unknown).

### is_low

```gdscript
func is_low(su: ScenarioUnit, t: String) -> bool
```

True if current/cap <= low threshold (and > 0).

### is_critical

```gdscript
func is_critical(su: ScenarioUnit, t: String) -> bool
```

True if current/cap <= critical threshold (and > 0).

### is_empty

```gdscript
func is_empty(su: ScenarioUnit, t: String) -> bool
```

True if current ammo is zero.

### consume

```gdscript
func consume(unit_id: String, t: String, amount: int = 1) -> bool
```

Decrease ammo for `unit_id` of type `t` by `amount`.
Returns true if ammo was consumed; false if blocked (missing type or empty).

### tick

```gdscript
func tick(delta: float) -> void
```

Start links for needy units and transfer rounds along active links.

### _within_radius

```gdscript
func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool
```

True if src is within its transfer radius of dst.

### _is_logistics

```gdscript
func _is_logistics(su: ScenarioUnit) -> bool
```

True if the unit should act as a logistics source.

### _needs_ammo

```gdscript
func _needs_ammo(su: ScenarioUnit) -> bool
```

True if any ammo type is below its cap, unit is alive, and is stationary.

### _has_stock

```gdscript
func _has_stock(su: ScenarioUnit) -> bool
```

True if unit has any stock left to transfer.

### _pick_link_for

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String
```

Pick a logistics source within radius that has stock (simple first-match).

### _begin_link

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void
```

Begin a resupply link from `src_id` to `dst_id`.

### _finish_link

```gdscript
func _finish_link(dst_id: String) -> void
```

Finish an active resupply link for `dst_id`.

### _transfer_tick

```gdscript
func _transfer_tick(delta: float) -> void
```

Transfer rounds for all active links using a fractional-rate accumulator so
low rates still work at high frame rates (e.g., 20 rps @ 60 FPS).

### _init_ammunition_from_equipment

```gdscript
func _init_ammunition_from_equipment(su: ScenarioUnit) -> void
```

Initialize ammunition capacities from equipment.
Scans equipment.weapons and calculates ammo capacity for each AmmoTypes.
`su` ScenarioUnit to initialize

## Member Data Documentation

### ammo_profile

```gdscript
var ammo_profile: AmmoProfile
```

Decorators: `@export`

Default caps/thresholds applied to newly registered units if missing.

### _units

```gdscript
var _units: Dictionary
```

### _positions

```gdscript
var _positions: Dictionary
```

### _logi

```gdscript
var _logi: Dictionary
```

### _active_links

```gdscript
var _active_links: Dictionary
```

### _xfer_accum

```gdscript
var _xfer_accum: Dictionary
```

## Signal Documentation

### ammo_low

```gdscript
signal ammo_low(unit_id: String)
```

Emitted when current/cap <= low threshold.

### ammo_critical

```gdscript
signal ammo_critical(unit_id: String)
```

Emitted when current/cap <= critical threshold.

### ammo_empty

```gdscript
signal ammo_empty(unit_id: String)
```

Emitted when current ammo hits zero.

### resupply_started

```gdscript
signal resupply_started(src_unit_id: String, dst_unit_id: String)
```

Emitted when a logistics unit begins resupplying a recipient.

### resupply_completed

```gdscript
signal resupply_completed(src_unit_id: String, dst_unit_id: String)
```

Emitted when resupply finishes (recipient full OR stock exhausted).

### supplier_exhausted

```gdscript
signal supplier_exhausted(src_unit_id: String)
```

Emitted when supplier runs out of ammunition stock.
