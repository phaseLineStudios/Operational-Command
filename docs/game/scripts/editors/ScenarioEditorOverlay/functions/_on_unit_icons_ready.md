# ScenarioEditorOverlay::_on_unit_icons_ready Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 712–716)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _on_unit_icons_ready(u: UnitData) -> void
```

- **u**: UnitData whose icons changed.

## Description

UnitData finished generating icons; drop scaled cache and redraw.

## Source

```gdscript
func _on_unit_icons_ready(u: UnitData) -> void:
	_invalidate_unit_icon_cache(u)
	queue_redraw()
```
