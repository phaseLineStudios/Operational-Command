# MilSymbolTest::_change_option_selection Function Reference

*Defined at:* `scripts/test/MilSymbolTest.gd` (lines 73–83)</br>
*Belongs to:* [MilSymbolTest](../../MilSymbolTest.md)

**Signature**

```gdscript
func _change_option_selection(ob: OptionButton, delta: int) -> void
```

- **ob**: The OptionButton to change.
- **delta**: +1 to move down/right, -1 to move up/left.

## Description

Increment/decrement selection on an OptionButton and emit item_selected.

## Source

```gdscript
func _change_option_selection(ob: OptionButton, delta: int) -> void:
	var count := ob.get_item_count()
	if count <= 0:
		return
	var new_idx := clampi(ob.selected + delta, 0, count - 1)
	if new_idx == ob.selected:
		return
	ob.select(new_idx)
	ob.emit_signal("item_selected", new_idx)
```
