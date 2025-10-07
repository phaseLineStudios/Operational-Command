# PathGrid::_call_main Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 841–849)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _call_main(method: String, a0: Variant = null, a1: Variant = null) -> void
```

## Source

```gdscript
func _call_main(method: String, a0: Variant = null, a1: Variant = null) -> void:
	if a0 == null and a1 == null:
		call_deferred(method)
	elif a0 != null and a1 == null:
		call_deferred(method, a0)
	elif a0 != null and a1 != null:
		call_deferred(method, a0, a1)
```
