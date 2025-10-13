# DebugMetricsDisplay::_exit_tree Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 121–124)</br>
*Belongs to:* [DebugMetricsDisplay](../../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Source

```gdscript
func _exit_tree() -> void:
	thread.wait_to_finish()
```
