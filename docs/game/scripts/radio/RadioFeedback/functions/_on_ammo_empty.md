# RadioFeedback::_on_ammo_empty Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 75–78)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_ammo_empty(uid: String) -> void
```

## Description

“Winchester” — out of ammo.

## Source

```gdscript
func _on_ammo_empty(uid: String) -> void:
	LogService.info("%s: Winchester" % uid, "Radio")
```
