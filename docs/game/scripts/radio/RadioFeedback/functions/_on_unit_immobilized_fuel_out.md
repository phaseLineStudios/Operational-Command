# RadioFeedback::_on_unit_immobilized_fuel_out Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 119–122)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_unit_immobilized_fuel_out(uid: String) -> void
```

## Description

A unit became immobilized due to fuel depletion.

## Source

```gdscript
func _on_unit_immobilized_fuel_out(uid: String) -> void:
	LogService.info("%s: Immobilized, out of fuel" % uid, "Radio")
```
