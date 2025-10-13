# Debrief::_init_units_tree_columns Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 361–387)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _init_units_tree_columns() -> void
```

## Description

Applies headers and column sizing rules to the Units tree.
Safe to call multiple times.

## Source

```gdscript
func _init_units_tree_columns() -> void:
	if _units_tree == null:
		return
	_units_tree.columns = 6
	_units_tree.column_titles_visible = true
	_units_tree.hide_root = true

	_units_tree.set_column_title(0, "Unit")
	_units_tree.set_column_title(1, "Status")
	_units_tree.set_column_title(2, "Kills")
	_units_tree.set_column_title(3, "WIA")
	_units_tree.set_column_title(4, "KIA")
	_units_tree.set_column_title(5, "XP")

	_units_tree.set_column_expand(0, true)
	if _units_tree.has_method("set_column_expand_ratio"):
		_units_tree.set_column_expand_ratio(0, 6)
		for i in range(1, 6):
			_units_tree.set_column_expand(i, true)
			_units_tree.set_column_expand_ratio(i, 1)
	else:
		_units_tree.set_column_expand(0, true)
		_units_tree.set_column_custom_minimum_width(0, 180)
		for i in range(1, 6):
			_units_tree.set_column_expand(i, false)
```
