# Debrief::_ready Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 87–98)</br>
*Belongs to:* [Debrief](../Debrief.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initializes node references, connects button handlers, prepares the Units tree,
draws the initial title, and aligns the right split after the first layout pass.

## Source

```gdscript
func _ready() -> void:
	_assert_nodes()
	_btn_retry.pressed.connect(_on_retry_pressed)
	_btn_continue.pressed.connect(_on_continue_pressed)
	_assign_btn.pressed.connect(_on_assign_pressed)
	_init_units_tree_columns()
	_update_title()

	await get_tree().process_frame
	_align_right_split()
```
