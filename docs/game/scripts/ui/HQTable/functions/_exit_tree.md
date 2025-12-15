# HQTable::_exit_tree Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 320–324)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Description

Clean up when exiting (clears session drawings)

## Source

```gdscript
func _exit_tree() -> void:
	if drawing_controller:
		drawing_controller.clear_all()
```
