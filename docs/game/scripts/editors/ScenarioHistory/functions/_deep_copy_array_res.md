# ScenarioHistory::_deep_copy_array_res Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 283–289)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _deep_copy_array_res(arr: Array) -> Array
```

## Source

```gdscript
static func _deep_copy_array_res(arr: Array) -> Array:
	var out := []
	for v in arr:
		out.append(_dup_res(v))
	return out
```
