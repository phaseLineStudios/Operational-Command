# RadioFeedback::bind_fuel Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 49–60)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func bind_fuel(fuel: FuelSystem) -> void
```

## Description

Bind to a FuelSystem instance to receive fuel/refuel events.
Safe to call multiple times; connects all relevant signals.

## Source

```gdscript
func bind_fuel(fuel: FuelSystem) -> void:
	if fuel == null:
		return
	fuel.fuel_low.connect(_on_fuel_low)
	fuel.fuel_critical.connect(_on_fuel_critical)
	fuel.fuel_empty.connect(_on_fuel_empty)
	fuel.refuel_started.connect(_on_fuel_refuel_started)
	fuel.refuel_completed.connect(_on_fuel_refuel_completed)
	fuel.unit_immobilized_fuel_out.connect(_on_unit_immobilized_fuel_out)
	fuel.unit_mobilized_after_refuel.connect(_on_unit_mobilized_after_refuel)
```
