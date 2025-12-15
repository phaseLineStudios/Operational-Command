# ScenarioEditor::_generate_unit_instance_id_for Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 581–600)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _generate_unit_instance_id_for(u: UnitData) -> String
```

## Description

Generate unique unit instance id based on UnitData.id

## Source

```gdscript
func _generate_unit_instance_id_for(u: UnitData) -> String:
	var base := String(u.id)
	if base.is_empty():
		base = "unit"
	var used := {}
	if ctx.data and ctx.data.units:
		var prefix := base + "_"
		for su in ctx.data.units:
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
