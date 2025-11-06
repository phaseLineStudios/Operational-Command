# UnitData::_queue_icon_update Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 157–162)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _queue_icon_update() -> void
```

## Description

Schedule an async icon refresh (debounced to next idle message).

## Source

```gdscript
func _queue_icon_update() -> void:
	_icon_rev += 1
	var my_rev := _icon_rev
	call_deferred("_update_icons_async", my_rev)
```
