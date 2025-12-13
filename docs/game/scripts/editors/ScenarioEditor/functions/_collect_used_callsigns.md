# ScenarioEditor::_collect_used_callsigns Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 527–545)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary
```

## Description

Build set of already-used callsigns for uniqueness checks

## Source

```gdscript
func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary:
	var used := {}
	if ctx.data == null:
		return used
	if ctx.data.units:
		for su in ctx.data.units:
			if su and su.affiliation == affiliation:
				var cs := String(su.callsign).strip_edges()
				if not cs.is_empty():
					used[cs] = true
	if ctx.data.unit_slots and affiliation == ScenarioUnit.Affiliation.FRIEND:
		for s in ctx.data.unit_slots:
			if s:
				var title := String(s.title).strip_edges()
				if not title.is_empty():
					used[title] = true
	return used
```
