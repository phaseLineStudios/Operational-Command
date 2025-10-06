# ScenarioEditorOverlay::begin_link_preview Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 369–374)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func begin_link_preview(src_pick: Dictionary) -> void
```

## Description

Begin live link line preview from a source pick

## Source

```gdscript
func begin_link_preview(src_pick: Dictionary) -> void:
	_link_preview_active = true
	_link_preview_src = src_pick
	queue_redraw()
```
