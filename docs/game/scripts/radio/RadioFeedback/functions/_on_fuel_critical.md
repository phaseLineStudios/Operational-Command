# RadioFeedback::_on_fuel_critical Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 99–102)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_fuel_critical(uid: String) -> void
```

## Description

“Fuel state red” — remaining fuel <= critical threshold but > 0.

## Source

```gdscript
func _on_fuel_critical(uid: String) -> void:
	LogService.info("%s: Fuel state red" % uid, "Radio")
```
