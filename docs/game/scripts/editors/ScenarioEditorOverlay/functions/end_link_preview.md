# ScenarioEditorOverlay::end_link_preview Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 383–388)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func end_link_preview() -> void
```

## Description

End live link preview and clear state

## Source

```gdscript
func end_link_preview() -> void:
	_link_preview_active = false
	_link_preview_src = {}
	queue_redraw()
```
