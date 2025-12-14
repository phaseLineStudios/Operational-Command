# DebugMenu::_populate_scene_list Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 97–111)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _populate_scene_list() -> void
```

## Description

populate optionbutton with scenes

## Source

```gdscript
func _populate_scene_list() -> void:
	scene_loader_scene.clear()
	var scenes := _collect_scenes("res://")
	scenes.sort_custom(func(a, b): return String(a).nocasecmp_to(String(b)) < 0)

	for p in scenes:
		var scene_name := _pretty_scene_name(p)
		var i := scene_loader_scene.item_count
		scene_loader_scene.add_item(scene_name)
		scene_loader_scene.set_item_metadata(i, p)

	if scene_loader_scene.item_count > 0:
		scene_loader_scene.select(0)
```
