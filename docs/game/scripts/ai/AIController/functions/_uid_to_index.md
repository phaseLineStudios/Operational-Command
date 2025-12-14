# AIController::_uid_to_index Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 570–579)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _uid_to_index(uid: String) -> int
```

## Source

```gdscript
func _uid_to_index(uid: String) -> int:
	if uid == "":
		return -1
	var idx := int(_unit_index_cache.get(uid, -1))
	if idx == -1:
		refresh_unit_index_cache()
		idx = int(_unit_index_cache.get(uid, -1))
	return idx
```
