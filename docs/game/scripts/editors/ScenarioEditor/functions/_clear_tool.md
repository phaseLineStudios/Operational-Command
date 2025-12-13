# ScenarioEditor::_clear_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 301–309)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _clear_tool() -> void
```

## Description

Clear current tool

## Source

```gdscript
func _clear_tool() -> void:
	LogService.trace("clear tool", "ScenarioEditor.gd:280")
	_set_tool(null)
	# Clear all draw tool button states
	draw_toolbar_freehand.set_pressed_no_signal(false)
	draw_toolbar_stamp.set_pressed_no_signal(false)
	draw_toolbar_eraser.set_pressed_no_signal(false)
```
