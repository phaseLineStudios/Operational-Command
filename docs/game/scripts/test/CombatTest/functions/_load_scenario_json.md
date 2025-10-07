# CombatTest::_load_scenario_json Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 97–105)</br>
*Belongs to:* [CombatTest](../../CombatTest.md)

**Signature**

```gdscript
func _load_scenario_json(path: String) -> Dictionary
```

## Source

```gdscript
func _load_scenario_json(path: String) -> Dictionary:
	if path == "" or not FileAccess.file_exists(path):
		push_warning("Scenario JSON not found: " + path)
		return {}
	var txt := FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(txt)
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}
```
