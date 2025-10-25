# RadioFeedback::_on_fuel_low Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 94–97)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_fuel_low(uid: String) -> void
```

## Description

“Low fuel” — remaining fuel <= low threshold but > critical.

## Source

```gdscript
func _on_fuel_low(uid: String) -> void:
	LogService.info("%s: Low fuel" % uid, "Radio")
```
