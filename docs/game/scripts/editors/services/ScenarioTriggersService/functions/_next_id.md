# ScenarioTriggersService::_next_id Function Reference

*Defined at:* `scripts/editors/services/ScenarioTriggersService.gd` (lines 37–50)</br>
*Belongs to:* [ScenarioTriggersService](../ScenarioTriggersService.md)

**Signature**

```gdscript
func _next_id(data: ScenarioData) -> String
```

## Source

```gdscript
static func _next_id(data: ScenarioData) -> String:
	var used := {}
	if data and data.triggers:
		for t in data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n
```
