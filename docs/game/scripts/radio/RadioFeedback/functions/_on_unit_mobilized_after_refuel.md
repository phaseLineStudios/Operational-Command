# RadioFeedback::_on_unit_mobilized_after_refuel Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 123–126)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_unit_mobilized_after_refuel(uid: String) -> void
```

## Description

A unit regained mobility after being refueled.

## Source

```gdscript
func _on_unit_mobilized_after_refuel(uid: String) -> void:
	LogService.info("%s: Mobility restored after refuel" % uid, "Radio")
```
