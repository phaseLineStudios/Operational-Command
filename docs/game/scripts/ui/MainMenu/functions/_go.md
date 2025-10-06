# MainMenu::_go Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 75–82)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _go(key: String) -> void
```

## Description

Change scene by key in SCENES.

## Source

```gdscript
func _go(key: String) -> void:
	var path: String = SCENES.get(key, "")
	if path == "" or not ResourceLoader.exists(path):
		_show_missing_scene_dialog(key, path)
		return
	Game.goto_scene(path)
```
