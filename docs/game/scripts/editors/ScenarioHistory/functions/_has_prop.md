# ScenarioHistory::_has_prop Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 304–312)</br>
*Belongs to:* [ScenarioHistory](../../ScenarioHistory.md)

**Signature**

```gdscript
func _has_prop(o: Object, p_name: String) -> bool
```

## Description

Does an Object expose a property with this name

## Source

```gdscript
static func _has_prop(o: Object, p_name: String) -> bool:
	if o == null:
		return false
	for pd in o.get_property_list():
		if String(pd["name"]) == p_name:
			return true
	return false
```
