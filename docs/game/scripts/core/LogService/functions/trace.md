# LogService::trace Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 57–63)</br>
*Belongs to:* [LogService](../LogService.md)

**Signature**

```gdscript
func trace(msg: String, src := "")
```

## Description

Log TRACE level rich message

## Source

```gdscript
func trace(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.TRACE, src)
	emit_signal("line", fmt_msg, LogLevel.TRACE)
	if _project_level >= LogLevel.TRACE:
		print_rich(fmt_msg)
```
