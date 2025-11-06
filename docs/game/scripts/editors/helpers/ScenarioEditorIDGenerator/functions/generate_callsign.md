# ScenarioEditorIDGenerator::generate_callsign Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 110–128)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String
```

- **affiliation**: Unit affiliation (FRIEND or ENEMY).
- **Return Value**: Unique callsign string.

## Description

Compute next available callsign for given affiliation.

## Source

```gdscript
func generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String:
	var pool := get_callsign_pool(affiliation)
	if pool.is_empty():
		return "UNIT"
	var used := collect_used_callsigns(affiliation)
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
