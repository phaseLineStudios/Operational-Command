# ScenarioEditorIDGenerator::next_slot_key Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 84–90)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func next_slot_key() -> String
```

- **Return Value**: Unique slot key string.

## Description

Generate next unique slot key (SLOT_n).

## Source

```gdscript
func next_slot_key() -> String:
	var n := 1
	if editor.ctx.data and editor.ctx.data.unit_slots:
		n = editor.ctx.data.unit_slots.size() + 1
	return "SLOT_%d" % n
```
