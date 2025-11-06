# LogService::debug Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 61–67)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func debug(msg: String, src := "")
```

- **msg**: Message to log.
- **src**: source of log message e.g. "LogService.gd:58"

## Description

Log a DEBUG level rich message.

## Source

```gdscript
func debug(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.DEBUG, src)
	emit_signal("line", fmt_msg, LogLevel.DEBUG)
	if _project_level >= LogLevel.DEBUG:
		print_rich(fmt_msg)
```
