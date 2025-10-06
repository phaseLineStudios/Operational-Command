# ScenarioEditorOverlay::clear_selected Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 101–105)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func clear_selected() -> void
```

## Description

Clear current selection highlight

## Source

```gdscript
func clear_selected() -> void:
	_selected_pick = {}
	queue_redraw()
```
