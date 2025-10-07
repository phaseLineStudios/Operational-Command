# AmmoRearmPanel::_ready Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 48–54)</br>
*Belongs to:* [AmmoRearmPanel](../../AmmoRearmPanel.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_lst_units.item_selected.connect(_on_unit_selected)
	_btn_full.pressed.connect(func(): _apply_fill_ratio(1.0))
	_btn_half.pressed.connect(func(): _apply_fill_ratio(0.5))
	_btn_commit.pressed.connect(_on_commit)
```
