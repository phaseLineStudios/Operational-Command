# ScenarioEditorMenus::open_slot_config Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 68–73)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func open_slot_config(index: int) -> void
```

- **index**: Slot index.

## Description

Open slot configuration dialog for a slot index.

## Source

```gdscript
func open_slot_config(index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.unit_slots:
		return
	editor.slot_cfg.show_for(editor, index)
```
