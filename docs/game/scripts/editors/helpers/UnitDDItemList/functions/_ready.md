# UnitDDItemList::_ready Function Reference

*Defined at:* `scripts/editors/helpers/UnitDDItemList.gd` (lines 18–22)</br>
*Belongs to:* [UnitDDItemList](../../UnitDDItemList.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if dialog_path != NodePath():
		_dlg = get_node_or_null(dialog_path)
```
