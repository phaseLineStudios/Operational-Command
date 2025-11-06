# UnitData::_init Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 152–155)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _init() -> void
```

## Source

```gdscript
func _init() -> void:
	call_deferred("_queue_icon_update")
```
