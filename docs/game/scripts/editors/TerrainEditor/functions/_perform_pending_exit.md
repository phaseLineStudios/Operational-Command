# TerrainEditor::_perform_pending_exit Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 167–174)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _perform_pending_exit() -> void
```

## Description

Exit application

## Source

```gdscript
func _perform_pending_exit() -> void:
	if _pending_exit_kind == "menu":
		Game.goto_scene(MAIN_MENU_SCENE)
	elif _pending_exit_kind == "app":
		get_tree().quit()
	_pending_exit_kind = ""
```
