# PathGrid::_emit_build_progress Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 872–875)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _emit_build_progress(p: float) -> void
```

## Source

```gdscript
func _emit_build_progress(p: float) -> void:
	emit_signal("build_progress", p)
```
