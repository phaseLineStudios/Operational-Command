# ScenarioEditorMenus::open_unit_config Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 76–81)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func open_unit_config(index: int) -> void
```

- **index**: Unit index.

## Description

Open unit configuration dialog for a unit index.

## Source

```gdscript
func open_unit_config(index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.units:
		return
	editor.unit_cfg.show_for(editor, index)
```
