# ScenarioEditorMenus::open_trigger_config Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 93–98)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func open_trigger_config(index: int) -> void
```

- **index**: Trigger index.

## Description

Open trigger configuration dialog for a trigger index.

## Source

```gdscript
func open_trigger_config(index: int) -> void:
	if index < 0 or index >= editor.ctx.data.triggers.size():
		return
	editor.trigger_cfg.show_for(editor, index)
```
