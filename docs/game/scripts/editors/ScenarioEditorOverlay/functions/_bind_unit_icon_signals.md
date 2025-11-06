# ScenarioEditorOverlay::_bind_unit_icon_signals Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 775–783)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _bind_unit_icon_signals() -> void
```

## Description

Connect to UnitData signals so we refresh when icons complete.

## Source

```gdscript
func _bind_unit_icon_signals() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.units == null:
		return
	for su: ScenarioUnit in editor.ctx.data.units:
		if su == null or su.unit == null:
			continue
		_ensure_bound_for_unit(su.unit)
```
