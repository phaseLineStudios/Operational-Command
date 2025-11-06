# ScenarioEditorOverlay::_clear_unit_icon_bindings Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 796–806)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _clear_unit_icon_bindings() -> void
```

## Description

Disconnect everything we previously bound.

## Source

```gdscript
func _clear_unit_icon_bindings() -> void:
	for u in _unit_signal_handles.keys():
		if is_instance_valid(u):
			var h: Variant = _unit_signal_handles[u]
			if u.is_connected("icons_ready", h.icons):
				u.icons_ready.disconnect(h.icons)
			if u.is_connected("changed", h.changed):
				u.changed.disconnect(h.changed)
	_unit_signal_handles.clear()
```
