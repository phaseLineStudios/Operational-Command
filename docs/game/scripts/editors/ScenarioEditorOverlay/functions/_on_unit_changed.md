# ScenarioEditorOverlay::_on_unit_changed Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 718–722)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _on_unit_changed(u: UnitData) -> void
```

## Description

Generic change fallback (covers editor-time tweaks).

## Source

```gdscript
func _on_unit_changed(u: UnitData) -> void:
	_invalidate_unit_icon_cache(u)
	queue_redraw()
```
