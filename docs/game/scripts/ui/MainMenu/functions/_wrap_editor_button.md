# MainMenu::_wrap_editor_button Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 103–129)</br>
*Belongs to:* [MainMenu](../../MainMenu.md)

**Signature**

```gdscript
func _wrap_editor_button() -> void
```

## Description

Reparents the Editor button into a VBox to host submenu buttons below it.

## Source

```gdscript
func _wrap_editor_button() -> void:
	if not (menu_hbox and btn_editor):
		return

	var idx := menu_hbox.get_children().find(btn_editor)
	if idx == -1:
		return

	_editor_wrapper = VBoxContainer.new()
	_editor_wrapper.name = "EditorWrapper"
	_editor_wrapper.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	menu_hbox.remove_child(btn_editor)
	menu_hbox.add_child(_editor_wrapper)
	menu_hbox.move_child(_editor_wrapper, idx)

	_editor_wrapper.add_child(btn_editor)

	_submenu_holder = VBoxContainer.new()
	_submenu_holder.name = "EditorSubmenu"
	_submenu_holder.visible = false
	_submenu_holder.add_theme_constant_override("separation", 6)
	_editor_wrapper.add_child(_submenu_holder)

	_build_submenu_buttons()
```
