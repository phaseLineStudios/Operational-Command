# HQTable::_wire_logistics_warnings Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 158–174)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _wire_logistics_warnings() -> void
```

## Description

Wire up ammo/fuel warning signals to auto-response system.

## Source

```gdscript
func _wire_logistics_warnings() -> void:
	if not sim:
		return

	# Connect ammo system warnings
	if sim.ammo_system:
		sim.ammo_system.ammo_low.connect(_on_ammo_low)
		sim.ammo_system.ammo_critical.connect(_on_ammo_critical)

	# Connect fuel system warnings
	if sim.fuel_system:
		sim.fuel_system.fuel_low.connect(_on_fuel_low)
		sim.fuel_system.fuel_critical.connect(_on_fuel_critical)

	LogService.trace("Logistics warnings wired to auto-response system.", "HQTable.gd")
```
