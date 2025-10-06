# ScenarioEditorOverlay::set_selected Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 95–99)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func set_selected(pick: Dictionary) -> void
```

## Description

Set current selection highlight

## Source

```gdscript
func set_selected(pick: Dictionary) -> void:
	_selected_pick = pick if pick != null else {}
	queue_redraw()
```
