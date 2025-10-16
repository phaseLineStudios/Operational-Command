# TriggerVM::_sorted_keys Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 95–102)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _sorted_keys(ctx: Dictionary) -> PackedStringArray
```

- **ctx**: becomes constants accessible in the expression.
- **Return Value**: Array of sorted keys.

## Description

Sorts context keys.

## Source

```gdscript
func _sorted_keys(ctx: Dictionary) -> PackedStringArray:
	var ks := PackedStringArray()
	for k in ctx.keys():
		ks.append(String(k))
	ks.sort()
	return ks
```
