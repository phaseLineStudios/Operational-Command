# RadioFeedback::_on_fuel_refuel_completed Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 114–117)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_fuel_refuel_completed(src: String, dst: String) -> void
```

## Description

Refuel operation completed successfully.

## Source

```gdscript
func _on_fuel_refuel_completed(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Refuel complete" % [src, dst], "Radio")
```
