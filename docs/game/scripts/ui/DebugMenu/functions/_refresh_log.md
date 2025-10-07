# DebugMenu::_refresh_log Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 106–123)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _refresh_log()
```

## Description

refresh log display

## Source

```gdscript
func _refresh_log():
	var filtered_lines := []
	for line in _log_lines:
		var lvl: LogService.LogLevel = line["lvl"]
		var txt: String = line["msg"]

		if (
			(lvl == LogService.LogLevel.LOG and event_log_filter_log.button_pressed)
			or (lvl == LogService.LogLevel.INFO and event_log_filter_info.button_pressed)
			or (lvl == LogService.LogLevel.WARNING and event_log_filter_warning.button_pressed)
			or (lvl == LogService.LogLevel.ERROR and event_log_filter_error.button_pressed)
			or (lvl == LogService.LogLevel.TRACE and event_log_filter_trace.button_pressed)
		):
			filtered_lines.append(txt)

	event_log_content.text = "\n".join(filtered_lines)
```
