# ScenarioEditorIDGenerator::collect_used_callsigns Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 157–175)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary
```

- **affiliation**: Unit affiliation (FRIEND or ENEMY).
- **Return Value**: Dictionary of used callsigns (keys are callsigns).

## Description

Build set of already-used callsigns for uniqueness checks.

## Source

```gdscript
func collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary:
	var used := {}
	if editor.ctx.data == null:
		return used
	if editor.ctx.data.units:
		for su in editor.ctx.data.units:
			if su and su.affiliation == affiliation:
				var cs := String(su.callsign).strip_edges()
				if not cs.is_empty():
					used[cs] = true
	if editor.ctx.data.unit_slots and affiliation == ScenarioUnit.Affiliation.FRIEND:
		for s in editor.ctx.data.unit_slots:
			if s:
				var title := String(s.title).strip_edges()
				if not title.is_empty():
					used[title] = true
	return used
```
