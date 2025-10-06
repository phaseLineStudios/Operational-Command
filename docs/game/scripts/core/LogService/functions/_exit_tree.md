# LogService::_exit_tree Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 20–24)</br>
*Belongs to:* [LogService](../LogService.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Source

```gdscript
func _exit_tree() -> void:
	if _tap:
		OS.remove_logger(_tap)
```
