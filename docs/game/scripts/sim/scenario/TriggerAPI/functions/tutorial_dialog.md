# TriggerAPI::tutorial_dialog Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 307–317)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void
```

- **text**: Dialog text to display (supports BBCode formatting)
- **node_identifier**: Node name, unique name (%), or path to point at
- **block**: If true (default), blocks execution until dialog is closed

## Description

Show a tutorial dialog with a line pointing to a UI element.
Designed for tutorial sequences to highlight specific tools, buttons, or UI elements.
Automatically pauses the simulation and points at the specified node.
By default, blocks execution until the dialog is dismissed (can be disabled).

## Source

```gdscript
func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void:
	if _mission_dialog and _mission_dialog.has_method("show_dialog"):
		var target = node_identifier as Variant if node_identifier != "" else null
		_mission_dialog.show_dialog(text, true, sim, null, map_controller, target)
		if block:
			_dialog_blocking = true
			# Connect to dialog_closed signal if not already connected
			if not _mission_dialog.is_connected("dialog_closed", _on_dialog_closed):
				_mission_dialog.dialog_closed.connect(_on_dialog_closed)
```
