# ScenarioEditor::_next_slot_key Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 499–505)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _next_slot_key() -> String
```

## Description

Generate next unique slot key (SLOT_n)

## Source

```gdscript
func _next_slot_key() -> String:
	var n := 1
	if ctx.data and ctx.data.unit_slots:
		n = ctx.data.unit_slots.size() + 1
	return "SLOT_%d" % n
```
