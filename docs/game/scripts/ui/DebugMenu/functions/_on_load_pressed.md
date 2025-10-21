# DebugMenu::_on_load_pressed Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 43–54)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _on_load_pressed() -> void
```

## Description

Load scene

## Source

```gdscript
func _on_load_pressed() -> void:
	var idx := scene_loader_scene.get_selected()
	if idx < 0:
		return
	var path: String = scene_loader_scene.get_item_metadata(idx)
	if path == "" or path == null:
		return

	Game.goto_scene(path)
	hide()
```
