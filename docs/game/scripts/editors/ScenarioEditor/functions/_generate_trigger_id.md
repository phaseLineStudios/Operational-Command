# ScenarioEditor::_generate_trigger_id Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 471–484)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _generate_trigger_id() -> String
```

## Description

Generate next unique trigger id (TRG_n)

## Source

```gdscript
func _generate_trigger_id() -> String:
	var used := {}
	if ctx.data and ctx.data.triggers:
		for t in ctx.data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n
```
