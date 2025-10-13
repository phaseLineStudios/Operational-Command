# LogService::_fmt_level Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 79–91)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func _fmt_level(lvl: LogLevel) -> String
```

## Description

Get formatted level string

## Source

```gdscript
func _fmt_level(lvl: LogLevel) -> String:
	match lvl:
		LogLevel.LOG:
			return "[bgcolor=white][color=black]   LOG   [/color][/bgcolor]"
		LogLevel.INFO:
			return "[bgcolor=#399b9c][color=black]  INFO   [/color][/bgcolor]"
		LogLevel.WARNING:
			return "[bgcolor=#dac663][color=black] WARNING [/color][/bgcolor]"
		LogLevel.ERROR:
			return "[bgcolor=#f8736d][color=black]  ERROR  [/color][/bgcolor]"
		LogLevel.TRACE:
			return "[bgcolor=#a78bb9][color=black]  TRACE  [/color][/bgcolor]"
	return ""
```
