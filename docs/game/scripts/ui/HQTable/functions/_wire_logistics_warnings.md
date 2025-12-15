# HQTable::_wire_logistics_warnings Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 222–238)</br>
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

	if sim.ammo_system:
		sim.ammo_system.ammo_low.connect(_on_ammo_low)
		sim.ammo_system.ammo_critical.connect(_on_ammo_critical)
		sim.ammo_system.resupply_started.connect(_on_resupply_started)
		sim.ammo_system.supplier_exhausted.connect(_on_ammo_supplier_exhausted)

	if sim.fuel_system:
		sim.fuel_system.fuel_low.connect(_on_fuel_low)
		sim.fuel_system.fuel_critical.connect(_on_fuel_critical)
		sim.fuel_system.refuel_started.connect(_on_refuel_started)
		sim.fuel_system.supplier_exhausted.connect(_on_fuel_supplier_exhausted)
```
