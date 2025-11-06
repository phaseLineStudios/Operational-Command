# TriggerAPI::tutorial_dialog Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 279–289)</br>
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
  
  

**Usage in trigger expressions:**

```
# Point to a node by unique name (% prefix) - blocks until dismissed
tutorial_dialog("This is the radio button. Press spacebar to transmit.", "%RadioButton")

# Point to a node by name (searches from root)
tutorial_dialog("Use this tool to draw on the map.", "DrawingTool")

# Point to a node by path
tutorial_dialog("These are your unit cards.", "HBoxContainer/UnitPanel")

# Tutorial sequence - automatically waits for each dialog to be dismissed
tutorial_dialog("Welcome to the mission!")
tutorial_dialog("This is the map viewer.", "%MapViewer")
tutorial_dialog("Click and drag to pan the map.", "%MapViewer")
tutorial_dialog("Press spacebar to use the radio.", "%RadioButton")

# Non-blocking tutorial dialog (old behavior with sleep_ui)
tutorial_dialog("Watch this!", "%SomeNode", false)
sleep_ui(3.0)
tutorial_dialog("Now this!", "%OtherNode", false)
```

  

**Note:** The dialog will automatically pause the simulation. Node lookup tries:
  
1. Unique name lookup (if starts with %)
  
2. Direct path from dialog node
  
3. Recursive search from root by name

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
