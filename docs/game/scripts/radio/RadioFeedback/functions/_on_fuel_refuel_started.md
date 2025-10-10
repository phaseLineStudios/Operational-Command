# RadioFeedback::_on_fuel_refuel_started Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 108–111)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_fuel_refuel_started(src: String, dst: String) -> void
```

## Description

Refuel operation started between two units.

## Source

```gdscript
func _on_fuel_refuel_started(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Refueling" % [src, dst], "Radio")
```
