# PathGrid::_emit_build_started Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 868–871)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _emit_build_started(profile: int) -> void
```

## Source

```gdscript
func _emit_build_started(profile: int) -> void:
	emit_signal("build_started", profile)
```
