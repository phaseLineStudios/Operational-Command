# LogService::_fmt_msg Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 71–77)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func _fmt_msg(msg: String, lvl: LogLevel, src := "") -> String
```

## Description

Get a formatted log message

## Source

```gdscript
func _fmt_msg(msg: String, lvl: LogLevel, src := "") -> String:
	var fmt_time = "[bgcolor=#3b3b3f][color=white] %s [/color][/bgcolor]" % _get_fmt_time()
	var fmt_lvl = _fmt_level(lvl)
	var fmt_src = " [color=#525457]%s[/color]" % src if src != "" else ""
	return "%s%s [color=white]%s[/color]%s" % [fmt_time, fmt_lvl, msg, fmt_src]
```
