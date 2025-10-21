# RadioFeedback::_on_fuel_empty Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 103–106)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_fuel_empty(uid: String) -> void
```

## Description

“Winchester fuel” — completely out of fuel.

## Source

```gdscript
func _on_fuel_empty(uid: String) -> void:
	LogService.info("%s: Winchester fuel" % uid, "Radio")
```
