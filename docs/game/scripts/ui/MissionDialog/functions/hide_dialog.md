# MissionDialog::hide_dialog Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 82–101)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func hide_dialog() -> void
```

## Description

Hide dialog and optionally resume game

## Source

```gdscript
func hide_dialog() -> void:
	visible = false

	# Hide line overlay
	if _line_overlay:
		_line_overlay.visible = false

	# Clear position, node, and map controller references
	_position_m = null
	_map_controller = null
	_target_node = null

	# Resume if we paused it
	if _should_unpause and _sim:
		_sim.resume()
		_should_unpause = false

	dialog_closed.emit()
```
