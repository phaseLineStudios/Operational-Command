# RadioFeedback::_on_ammo_low Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 66–69)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_ammo_low(uid: String) -> void
```

## Description

“Bingo ammo” — remaining ammo <= low threshold but > 0.

## Source

```gdscript
func _on_ammo_low(uid: String) -> void:
	LogService.info("%s: Bingo ammo" % uid, "Radio")
```
