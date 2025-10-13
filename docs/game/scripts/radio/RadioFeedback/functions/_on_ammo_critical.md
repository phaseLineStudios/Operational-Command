# RadioFeedback::_on_ammo_critical Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 70–73)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_ammo_critical(uid: String) -> void
```

## Description

“Ammo critical” — remaining ammo <= critical threshold but > 0.

## Source

```gdscript
func _on_ammo_critical(uid: String) -> void:
	LogService.info("%s: Ammo critical" % uid, "Radio")
```
