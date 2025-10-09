# ScenarioEditor::_generate_callsign Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 797–815)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String
```

## Description

Compute next available callsign for given affiliation

## Source

```gdscript
func _generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String:
	var pool := _get_callsign_pool(affiliation)
	if pool.is_empty():
		return "UNIT"
	var used := _collect_used_callsigns(affiliation)
	var cls_wrap := 0
	var idx := 0
	while true:
		var base := pool[idx]
		var candidate := base if (cls_wrap == 0) else "%s-%d" % [base, cls_wrap]
		if not used.has(candidate):
			return candidate
		idx += 1
		if idx >= pool.size():
			idx = 0
			cls_wrap += 1
	return "UNIT"
```
