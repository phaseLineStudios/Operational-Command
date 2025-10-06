# ScenarioHistory::_get_id Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 220–229)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _get_id(res: Resource) -> String
```

## Description

Get id/key from a Resource

## Source

```gdscript
func _get_id(res: Resource) -> String:
	if res == null:
		return ""
	if _has_prop(res, "id"):
		return String(res.get("id"))
	if _has_prop(res, "key"):
		return String(res.get("key"))
	return ""
```
