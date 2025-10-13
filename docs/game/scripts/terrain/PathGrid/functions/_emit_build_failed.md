# PathGrid::_emit_build_failed Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 866–869)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _emit_build_failed(reason: String) -> void
```

## Source

```gdscript
func _emit_build_failed(reason: String) -> void:
	emit_signal("build_failed", reason)
```
