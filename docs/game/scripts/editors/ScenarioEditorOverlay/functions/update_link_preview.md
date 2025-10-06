# ScenarioEditorOverlay::update_link_preview Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 376–381)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func update_link_preview(mouse_pos: Vector2) -> void
```

## Description

Update live link preview endpoint (mouse)

## Source

```gdscript
func update_link_preview(mouse_pos: Vector2) -> void:
	_link_preview_pos = mouse_pos
	if _link_preview_active:
		queue_redraw()
```
