# ScenarioHistory::_apply_array Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 165–180)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _apply_array(data: Resource, array_name: String, value: Array) -> void
```

## Source

```gdscript
func _apply_array(data: Resource, array_name: String, value: Array) -> void:
	var current: Array = data.get(array_name)

	if typeof(current) == TYPE_ARRAY:
		var cur := current as Array
		cur.clear()
		for v in value:
			cur.append(_dup_res(v))

		data.set(array_name, cur)
	else:
		data.set(array_name, _deep_copy_array_res(value))

	_emit_changed(data)
```
