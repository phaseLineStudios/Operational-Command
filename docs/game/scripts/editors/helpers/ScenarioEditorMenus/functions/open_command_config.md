# ScenarioEditorMenus::open_command_config Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 101–104)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func open_command_config(index: int) -> void
```

- **index**: Custom command index.

## Description

Open custom command configuration dialog for a command index.

## Source

```gdscript
func open_command_config(index: int) -> void:
	if index < 0 or index >= editor.ctx.data.custom_commands.size():
		return
	editor.command_cfg.show_for(editor, index)
```
