# LogService::_enter_tree Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 14–19)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func _enter_tree() -> void
```

## Source

```gdscript
func _enter_tree() -> void:
	_tap = LogTap.new()
	_tap.message.connect(_captured_log)
	OS.add_logger(_tap)
```
