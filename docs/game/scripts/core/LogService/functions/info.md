# LogService::info Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 33–39)</br>
*Belongs to:* [LogService](../LogService.md)

**Signature**

```gdscript
func info(msg: String, src := "")
```

## Description

Log INFO level rich message

## Source

```gdscript
func info(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.INFO, src)
	emit_signal("line", fmt_msg, LogLevel.INFO)
	if _project_level >= LogLevel.INFO:
		print_rich(fmt_msg)
```
