# UnitBaseTask::get_configurable_props Function Reference

*Defined at:* `scripts/editors/tasks/UnitBaseTask.gd` (lines 19–42)</br>
*Belongs to:* [UnitBaseTask](../UnitBaseTask.md)

**Signature**

```gdscript
func get_configurable_props() -> Array[Dictionary]
```

## Description

Return list of exported properties for dynamic config UIs.

## Source

```gdscript
func get_configurable_props() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for p in get_property_list():
		if (p.usage & PROPERTY_USAGE_EDITOR) == 0:
			continue
		var name := String(p.name)
		if (
			name
			in [
				"resource_local_to_scene",
				"resource_path",
				"type_id",
				"display_name",
				"color",
				"icon",
				"script",
				"resource_name"
			]
		):
			continue
		list.append(p)
	return list
```
