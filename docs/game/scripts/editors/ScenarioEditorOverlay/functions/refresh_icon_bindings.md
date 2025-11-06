# ScenarioEditorOverlay::refresh_icon_bindings Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 769–773)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func refresh_icon_bindings() -> void
```

## Description

(Re)bind overlay to all units in the current ctx.

## Source

```gdscript
func refresh_icon_bindings() -> void:
	_clear_unit_icon_bindings()
	_bind_unit_icon_signals()
```
