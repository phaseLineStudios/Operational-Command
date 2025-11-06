# ScenarioEditorIDGenerator::generate_unit_instance_id_for Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 179–196)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func generate_unit_instance_id_for(u: UnitData) -> String
```

- **u**: Unit data to generate instance ID for.
- **Return Value**: Unique unit instance ID string.

## Description

Generate unique unit instance id based on UnitData.id.

## Source

```gdscript
func generate_unit_instance_id_for(u: UnitData) -> String:
	var base := String(u.id)
	if base.is_empty():
		base = "unit"
	var used := {}
	if editor.ctx.data and editor.ctx.data.units:
		var prefix := base + "_"
		for su in editor.ctx.data.units:
			if su and su.unit and String(su.unit.id) == base and su.id is String:
				var sid: String = su.id
				if sid.begins_with(prefix):
					var suffix := sid.substr(prefix.length())
					if suffix.is_valid_int():
						used[int(suffix)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "%s_%d" % [base, n]
```
