# AIController::_cmp_by_src_index Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 189–192)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _cmp_by_src_index(a: Dictionary, b: Dictionary) -> bool
```

## Description

Sort helper to keep original authoring order when no explicit links exist.

## Source

```gdscript
static func _cmp_by_src_index(a: Dictionary, b: Dictionary) -> bool:
	return int(a.get("__src_index", 0)) < int(b.get("__src_index", 0))
```
