# LogService::error Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 49–55)</br>
*Belongs to:* [LogService](../LogService.md)

**Signature**

```gdscript
func error(msg: String, src := "")
```

## Description

Log ERROR level rich message

## Source

```gdscript
func error(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.ERROR, src)
	emit_signal("line", fmt_msg, LogLevel.ERROR)
	if _project_level >= LogLevel.ERROR:
		print_rich(fmt_msg)
```
