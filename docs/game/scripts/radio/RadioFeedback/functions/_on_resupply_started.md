# RadioFeedback::_on_resupply_started Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 80–83)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_resupply_started(src: String, dst: String) -> void
```

## Description

Logistics unit began resupplying a recipient.

## Source

```gdscript
func _on_resupply_started(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Resupplying" % [src, dst], "Radio")
```
