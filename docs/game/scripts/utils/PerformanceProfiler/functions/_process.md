# PerformanceProfiler::_process Function Reference

*Defined at:* `scripts/utils/PerformanceProfiler.gd` (lines 11–15)</br>
*Belongs to:* [PerformanceProfiler](../../PerformanceProfiler.md)

**Signature**

```gdscript
func _process(_delta: float) -> void
```

## Source

```gdscript
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_filedialog_refresh"):  # F12
		_print_stats()
```
