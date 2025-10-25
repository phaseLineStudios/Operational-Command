# DebugOverlay::set_fuel_system Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 42–46)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func set_fuel_system(fs: FuelSystem) -> void
```

## Description

Optionally bind FuelSystem explicitly if you do not use the group.

## Source

```gdscript
func set_fuel_system(fs: FuelSystem) -> void:
	_fuel = fs
	queue_redraw()
```
