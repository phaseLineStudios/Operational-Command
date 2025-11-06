# ScenarioEditor::_rebuild_command_list Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 615–624)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _rebuild_command_list() -> void
```

## Description

Rebuild the custom commands list from scenario data

## Source

```gdscript
func _rebuild_command_list() -> void:
	command_list.clear()
	if not ctx.data:
		return
	for cmd in ctx.data.custom_commands:
		if cmd is CustomCommand:
			var text := cmd.keyword if cmd.keyword != "" else "(empty)"
			command_list.add_item(text)
```
