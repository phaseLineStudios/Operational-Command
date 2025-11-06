# ScenarioEditorIDGenerator::generate_trigger_id Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 93–106)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func generate_trigger_id() -> String
```

- **Return Value**: Unique trigger ID string.

## Description

Generate next unique trigger id (TRG_n).

## Source

```gdscript
func generate_trigger_id() -> String:
	var used := {}
	if editor.ctx.data and editor.ctx.data.triggers:
		for t in editor.ctx.data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n
```
