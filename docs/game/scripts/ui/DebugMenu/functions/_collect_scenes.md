# DebugMenu::_collect_scenes Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 113–118)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _collect_scenes(root: String) -> Array
```

## Description

Collect all scenes

## Source

```gdscript
func _collect_scenes(root: String) -> Array:
	var out: Array = []
	_recursive_collect_scenes(root, out)
	return out
```
