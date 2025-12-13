# OCMenuItemList::_ready Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 17–21)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	item_clicked.connect(_on_item_clicked)
	mouse_exited.connect(_on_mouse_exited)
```
