# LogService::warning Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 41–47)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func warning(msg: String, src := "")
```

## Description

Log WARNING level rich message

## Source

```gdscript
func warning(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.WARNING, src)
	emit_signal("line", fmt_msg, LogLevel.WARNING)
	if _project_level >= LogLevel.WARNING:
		print_rich(fmt_msg)
```
