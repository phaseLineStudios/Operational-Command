# Debrief::_assert_nodes Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 348–358)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _assert_nodes() -> void
```

## Description

Emits editor warnings if required scene nodes are missing.

## Source

```gdscript
func _assert_nodes() -> void:
	if _objectives_list == null:
		push_warning("Objectives ItemList missing.")
	if _units_tree == null:
		push_warning("Units Tree missing.")
	if _recipient_dd == null or _award_dd == null:
		push_warning("Commendation dropdowns missing.")
	if _assign_btn == null:
		push_warning("Assign Button missing.")
```
