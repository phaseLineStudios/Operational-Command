# OrdersRouter Class Reference

*File:* `scripts/sim/OrdersRouter.gd`
*Class name:* `OrdersRouter`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name OrdersRouter
extends Node
```

## Brief

Orders router for validated commands.

## Detailed Description

Routes parsed orders to movement/LOS/combat adapters and utilities.
Supports MOVE, HOLD, CANCEL, ATTACK, DEFEND, RECON, FIRE, REPORT.

Map OrdersParser.OrderType enum indices to string tokens.

Movement adapter used to plan and start moves.

LOS adapter used for visibility-related routing.

Combat controller used to set intent/targets and fire missions.

Compute a concrete destination from an order.
Priority: target unit (when [param prefer_target]) -> grid position
-> label via target_callsign -> plain target_callsign unit -> direction+quantity.
When a label is detected in `target_callsign`, returns a Vector2 position
resolved through the movement adapter.
[param unit] Subject unit (for direction-based movement).
[param order] Order dictionary.
[param prefer_target] If `true`, prefer unit target for ATTACK.
[return] Vector2 destination or `null` if none.

## Public Member Functions

- [`func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void`](OrdersRouter/functions/bind_units.md) — Supply unit indices used by this router.
- [`func apply(order: Dictionary) -> bool`](OrdersRouter/functions/apply.md) — Apply a single validated order.
- [`func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_move.md) — MOVE: compute destination from grid, target_callsign (unit or label), or direction+quantity.
- [`func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_hold.md) — HOLD/CANCEL: stop movement and clear combat intent (if supported).
- [`func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_attack.md) — ATTACK: prefer target_callsign; otherwise use movement fallback.
- [`func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_defend.md) — DEFEND: move to destination if present; otherwise hold.
- [`func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_recon.md) — RECON: move with recon posture if supported.
- [`func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_fire.md) — FIRE: request fire mission if possible; else move to target unit.
- [`func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool`](OrdersRouter/functions/_apply_report.md) — REPORT: informational pass-through.
- [`func _resolve_target(order: Dictionary) -> ScenarioUnit`](OrdersRouter/functions/_resolve_target.md) — Resolve a unit from `target_callsign`.
- [`func _is_label_name(l_name: String) -> bool`](OrdersRouter/functions/_is_label_name.md) — Test whether a string matches a TerrainData label (tolerant).
- [`func _norm_label(s: String) -> String`](OrdersRouter/functions/_norm_label.md) — Normalize label text for matching (lowercase, strip punctuation, collapse spaces).
- [`func _normalize_type(t: Variant) -> String`](OrdersRouter/functions/_normalize_type.md) — Normalize an order type to its string token.
- [`func _dir_to_vec(dir: String) -> Vector2`](OrdersRouter/functions/_dir_to_vec.md) — Convert a cardinal/intercardinal label to a unit vector (meters space).
- [`func _quantity_to_meters(qty: int, zone: String) -> float`](OrdersRouter/functions/_quantity_to_meters.md) — Convert a quantity and zone to meters.

## Public Attributes

- `MovementAdapter movement_adapter`
- `LOSAdapter los_adapter`
- `CombatController combat_controller`
- `Dictionary _units_by_id` — Terrain renderer for grid/metric conversions.
- `Dictionary _units_by_callsign`

## Signals

- `signal order_applied(order: Dictionary)` — Emitted when an order is applied to a unit.
- `signal order_failed(order: Dictionary, reason: String)` — Emitted when an order cannot be applied.

## Member Function Documentation

### bind_units

```gdscript
func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void
```

Supply unit indices used by this router.
[param id_index] Dictionary String->ScenarioUnit (by unit id).
[param callsign_index] Dictionary String->unit_id (by callsign).

### apply

```gdscript
func apply(order: Dictionary) -> bool
```

Apply a single validated order.
[param order] Normalized order dictionary from OrdersParser.
[return] `true` if applied, otherwise `false`.

### _apply_move

```gdscript
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool
```

MOVE: compute destination from grid, target_callsign (unit or label), or direction+quantity.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if movement was planned/started, else `false`.

### _apply_hold

```gdscript
func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool
```

HOLD/CANCEL: stop movement and clear combat intent (if supported).
[param unit] Subject unit.
[param order] Order dictionary.
[return] Always `true`.

### _apply_attack

```gdscript
func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool
```

ATTACK: prefer target_callsign; otherwise use movement fallback.
[param unit] Subject unit.
[param order] Order dictionary.
[return] Always `true` (intent set even if no move).

### _apply_defend

```gdscript
func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool
```

DEFEND: move to destination if present; otherwise hold.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if applied.

### _apply_recon

```gdscript
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool
```

RECON: move with recon posture if supported.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if applied, `false` if missing destination.

### _apply_fire

```gdscript
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool
```

FIRE: request fire mission if possible; else move to target unit.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if applied, otherwise `false`.

### _apply_report

```gdscript
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool
```

REPORT: informational pass-through.
[param _unit] Subject unit (unused).
[param order] Order dictionary.
[return] Always `true`.

### _resolve_target

```gdscript
func _resolve_target(order: Dictionary) -> ScenarioUnit
```

Resolve a unit from `target_callsign`.
[param order] Order dictionary.
[return] ScenarioUnit or `null`.

### _is_label_name

```gdscript
func _is_label_name(l_name: String) -> bool
```

Test whether a string matches a TerrainData label (tolerant).
[param l_name] Candidate label text.
[return] `true` if a matching label exists.

### _norm_label

```gdscript
func _norm_label(s: String) -> String
```

Normalize label text for matching (lowercase, strip punctuation, collapse spaces).
[param s] Input text.
[return] Normalized key string.

### _normalize_type

```gdscript
func _normalize_type(t: Variant) -> String
```

Normalize an order type to its string token.
[param t] Enum index or string.
[return] Uppercase type token.

### _dir_to_vec

```gdscript
func _dir_to_vec(dir: String) -> Vector2
```

Convert a cardinal/intercardinal label to a unit vector (meters space).
[param dir] Direction label (e.g. "NE", "southwest").
[return] Vector2 direction (length may be 0 if unknown).

### _quantity_to_meters

```gdscript
func _quantity_to_meters(qty: int, zone: String) -> float
```

Convert a quantity and zone to meters.
[param qty] Quantity value.
[param zone] Unit label (e.g. "m", "km", "grid").
[return] Distance in meters.

## Member Data Documentation

### movement_adapter

```gdscript
var movement_adapter: MovementAdapter
```

### los_adapter

```gdscript
var los_adapter: LOSAdapter
```

### combat_controller

```gdscript
var combat_controller: CombatController
```

### _units_by_id

```gdscript
var _units_by_id: Dictionary
```

Decorators: `@export var terrain_renderer: TerrainRender`

Terrain renderer for grid/metric conversions.

### _units_by_callsign

```gdscript
var _units_by_callsign: Dictionary
```

## Signal Documentation

### order_applied

```gdscript
signal order_applied(order: Dictionary)
```

Emitted when an order is applied to a unit.

### order_failed

```gdscript
signal order_failed(order: Dictionary, reason: String)
```

Emitted when an order cannot be applied.
