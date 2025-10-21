# PathGrid::_exit_tree Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 82–90)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Source

```gdscript
func _exit_tree() -> void:
	if _build_running:
		_build_cancel = true
		await get_tree().process_frame
	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null
```
