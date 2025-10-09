# RadioFeedback::_on_resupply_completed Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 86–89)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_resupply_completed(src: String, dst: String) -> void
```

## Description

Resupply finished because the recipient is full or the source ran out of stock.

## Source

```gdscript
func _on_resupply_completed(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Resupply complete" % [src, dst], "Radio")
```
