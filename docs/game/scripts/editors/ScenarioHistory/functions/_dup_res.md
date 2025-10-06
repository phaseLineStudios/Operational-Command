# ScenarioHistory::_dup_res Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 277–282)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _dup_res(r)
```

## Source

```gdscript
static func _dup_res(r):
	if r is Resource:
		return (r as Resource).duplicate(true)
	return r
```
