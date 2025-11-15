# DebugMenu::_log_msg Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 146–150)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _log_msg(msg: String, lvl: LogService.LogLevel) -> void
```

## Description

Capture and store log message

## Source

```gdscript
func _log_msg(msg: String, lvl: LogService.LogLevel) -> void:
	_log_lines.append({"msg": msg, "lvl": lvl})
	_refresh_log()
```
