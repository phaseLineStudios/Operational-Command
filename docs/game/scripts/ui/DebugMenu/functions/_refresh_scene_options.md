# DebugMenu::_refresh_scene_options Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 177–191)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _refresh_scene_options() -> void
```

## Description

Refresh scene options by scanning all nodes

## Source

```gdscript
func _refresh_scene_options() -> void:
	if _is_scanning:
		return

	_is_scanning = true
	scene_options_status.text = "Scanning..."
	scene_options_refresh.disabled = true

	# Clear existing options
	_clear_scene_options_ui()

	# Start async scan
	_scan_scene_for_options.call_deferred()
```
