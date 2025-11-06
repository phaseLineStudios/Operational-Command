# ScenarioEditorOverlay::_ensure_bound_for_unit Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 785–794)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _ensure_bound_for_unit(u: UnitData) -> void
```

## Description

Ensure we are bound for this UnitData (idempotent).

## Source

```gdscript
func _ensure_bound_for_unit(u: UnitData) -> void:
	if _unit_signal_handles.has(u):
		return
	var c_icons := Callable(self, "_on_unit_icons_ready").bind(u)
	var c_changed := Callable(self, "_on_unit_changed").bind(u)
	u.icons_ready.connect(c_icons)
	u.changed.connect(c_changed)
	_unit_signal_handles[u] = {"icons": c_icons, "changed": c_changed}
```
