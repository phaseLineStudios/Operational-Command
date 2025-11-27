# ScenarioEditorOverlay::_ready Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 64–73)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize popup menu and mouse handling

## Source

```gdscript
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true

	_ctx = PopupMenu.new()
	add_child(_ctx)
	_ctx.id_pressed.connect(_on_ctx_pressed)
	call_deferred("refresh_icon_bindings")
```
