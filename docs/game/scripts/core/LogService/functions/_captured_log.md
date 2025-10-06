# LogService::_captured_log Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 26–31)</br>
*Belongs to:* [LogService](../LogService.md)

**Signature**

```gdscript
func _captured_log(_level, msg: String)
```

## Description

Log generic message

## Source

```gdscript
func _captured_log(_level, msg: String):
	var fmt_msg := _fmt_msg(msg, LogLevel.LOG)
	print_rich(fmt_msg)
	emit_signal("line", fmt_msg, LogLevel.LOG)
```
