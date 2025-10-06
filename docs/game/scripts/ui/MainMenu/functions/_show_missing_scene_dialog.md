# MainMenu::_show_missing_scene_dialog Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 88–95)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _show_missing_scene_dialog(key: String, path: String) -> void
```

## Description

Used in development for missing scenes.

## Source

```gdscript
func _show_missing_scene_dialog(key: String, path: String) -> void:
	var dlg := AcceptDialog.new()
	dlg.title = "Unavailable"
	dlg.dialog_text = "The scene for '%s' isn't available yet.\nPath: %s" % [key, path]
	add_child(dlg)
	dlg.popup_centered()
```
