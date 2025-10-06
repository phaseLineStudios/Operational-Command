# LogTap::_log_message Function Reference

*Defined at:* `scripts/core/Logger.gd` (lines 9–12)</br>
*Belongs to:* [LogTap](../LogTap.md)

**Signature**

```gdscript
func _log_message(msg, _err)
```

## Description

Log a message

## Source

```gdscript
func _log_message(msg, _err):
	if msg.begins_with("[48"):
		return
	emit_signal("message", 0, str(msg.trim_suffix("\n")))
```
