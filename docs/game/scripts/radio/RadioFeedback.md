# RadioFeedback Class Reference

*File:* `scripts/radio/RadioFeedback.gd`
*Class name:* `RadioFeedback`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name RadioFeedback
extends Node
```

## Brief

Catches when an invalid command is emitted from parsed order and plays
an audio to inform the player

Ammo: RadioFeedback
Subscribes to AmmoSystem and order-parse events and surfaces them to the player.

## Detailed Description

In this basic implementation, messages are logged via `LogService` and an error
If present in a scene, call `bind_ammo(...)` or let `_ready()` auto-bind by group lookup.

Fuel: RadioFeedback
Subscribes to FuelSystem and order-parse events and surfaces them to the player.
In this basic implementation, messages are logged via `LogService` and an error sound is played.
If present in a scene, call `bind_fuel(...)` or let `_ready()` auto-bind by group lookup.

## Public Member Functions

- [`func _ready() -> void`](RadioFeedback/functions/_ready.md) — Ready-time setup:
- Connect to `OrdersParser.parse_error`
- Try to locate `AmmoSystem` and `FuelSystem` instances in the scene by group lookup.
- [`func bind_ammo(ammo: AmmoSystem) -> void`](RadioFeedback/functions/bind_ammo.md) — Bind to an AmmoSystem instance to receive ammo/resupply events.
- [`func bind_fuel(fuel: FuelSystem) -> void`](RadioFeedback/functions/bind_fuel.md) — Bind to a FuelSystem instance to receive fuel/refuel events.
- [`func _on_ammo_low(uid: String) -> void`](RadioFeedback/functions/_on_ammo_low.md) — “Bingo ammo” — remaining ammo <= low threshold but > 0.
- [`func _on_ammo_critical(uid: String) -> void`](RadioFeedback/functions/_on_ammo_critical.md) — “Ammo critical” — remaining ammo <= critical threshold but > 0.
- [`func _on_ammo_empty(uid: String) -> void`](RadioFeedback/functions/_on_ammo_empty.md) — “Winchester” — out of ammo.
- [`func _on_resupply_started(src: String, dst: String) -> void`](RadioFeedback/functions/_on_resupply_started.md) — Logistics unit began resupplying a recipient.
- [`func _on_resupply_completed(src: String, dst: String) -> void`](RadioFeedback/functions/_on_resupply_completed.md) — Resupply finished because the recipient is full or the source ran out of stock.
- [`func _on_fuel_low(uid: String) -> void`](RadioFeedback/functions/_on_fuel_low.md) — “Low fuel” — remaining fuel <= low threshold but > critical.
- [`func _on_fuel_critical(uid: String) -> void`](RadioFeedback/functions/_on_fuel_critical.md) — “Fuel state red” — remaining fuel <= critical threshold but > 0.
- [`func _on_fuel_empty(uid: String) -> void`](RadioFeedback/functions/_on_fuel_empty.md) — “Winchester fuel” — completely out of fuel.
- [`func _on_fuel_refuel_started(src: String, dst: String) -> void`](RadioFeedback/functions/_on_fuel_refuel_started.md) — Refuel operation started between two units.
- [`func _on_fuel_refuel_completed(src: String, dst: String) -> void`](RadioFeedback/functions/_on_fuel_refuel_completed.md) — Refuel operation completed successfully.
- [`func _on_unit_immobilized_fuel_out(uid: String) -> void`](RadioFeedback/functions/_on_unit_immobilized_fuel_out.md) — A unit became immobilized due to fuel depletion.
- [`func _on_unit_mobilized_after_refuel(uid: String) -> void`](RadioFeedback/functions/_on_unit_mobilized_after_refuel.md) — A unit regained mobility after being refueled.
- [`func _on_parse_error(error: String) -> void`](RadioFeedback/functions/_on_parse_error.md) — Order parser signaled an error (e.g., invalid command).

## Public Attributes

- `AudioStreamPlayer2D error_player` — UI audio for parse errors (must exist in the scene tree at %ErrorSound).
- `Radio radio_controller`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Ready-time setup:
- Connect to `OrdersParser.parse_error`
- Try to locate `AmmoSystem` and `FuelSystem` instances in the scene by group lookup.

### bind_ammo

```gdscript
func bind_ammo(ammo: AmmoSystem) -> void
```

Bind to an AmmoSystem instance to receive ammo/resupply events.
Safe to call multiple times; connects all relevant signals.

### bind_fuel

```gdscript
func bind_fuel(fuel: FuelSystem) -> void
```

Bind to a FuelSystem instance to receive fuel/refuel events.
Safe to call multiple times; connects all relevant signals.

### _on_ammo_low

```gdscript
func _on_ammo_low(uid: String) -> void
```

“Bingo ammo” — remaining ammo <= low threshold but > 0.

### _on_ammo_critical

```gdscript
func _on_ammo_critical(uid: String) -> void
```

“Ammo critical” — remaining ammo <= critical threshold but > 0.

### _on_ammo_empty

```gdscript
func _on_ammo_empty(uid: String) -> void
```

“Winchester” — out of ammo.

### _on_resupply_started

```gdscript
func _on_resupply_started(src: String, dst: String) -> void
```

Logistics unit began resupplying a recipient.

### _on_resupply_completed

```gdscript
func _on_resupply_completed(src: String, dst: String) -> void
```

Resupply finished because the recipient is full or the source ran out of stock.

### _on_fuel_low

```gdscript
func _on_fuel_low(uid: String) -> void
```

“Low fuel” — remaining fuel <= low threshold but > critical.

### _on_fuel_critical

```gdscript
func _on_fuel_critical(uid: String) -> void
```

“Fuel state red” — remaining fuel <= critical threshold but > 0.

### _on_fuel_empty

```gdscript
func _on_fuel_empty(uid: String) -> void
```

“Winchester fuel” — completely out of fuel.

### _on_fuel_refuel_started

```gdscript
func _on_fuel_refuel_started(src: String, dst: String) -> void
```

Refuel operation started between two units.

### _on_fuel_refuel_completed

```gdscript
func _on_fuel_refuel_completed(src: String, dst: String) -> void
```

Refuel operation completed successfully.

### _on_unit_immobilized_fuel_out

```gdscript
func _on_unit_immobilized_fuel_out(uid: String) -> void
```

A unit became immobilized due to fuel depletion.

### _on_unit_mobilized_after_refuel

```gdscript
func _on_unit_mobilized_after_refuel(uid: String) -> void
```

A unit regained mobility after being refueled.

### _on_parse_error

```gdscript
func _on_parse_error(error: String) -> void
```

Order parser signaled an error (e.g., invalid command). Plays a short error sound.

## Member Data Documentation

### error_player

```gdscript
var error_player: AudioStreamPlayer2D
```

Decorators: `@onready`

UI audio for parse errors (must exist in the scene tree at %ErrorSound).

### radio_controller

```gdscript
var radio_controller: Radio
```
