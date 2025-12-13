# DebugMenu::_clear_scene_options_ui Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 194–198)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _clear_scene_options_ui() -> void
```

## Description

Clear all scene option UI elements

## Source

```gdscript
func _clear_scene_options_ui() -> void:
	for child in scene_options_container.get_children():
		child.queue_free()
```
