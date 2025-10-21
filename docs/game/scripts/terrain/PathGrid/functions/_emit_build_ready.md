# PathGrid::_emit_build_ready Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 862–865)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _emit_build_ready(profile: int) -> void
```

## Source

```gdscript
func _emit_build_ready(profile: int) -> void:
	emit_signal("build_ready", profile)
```
