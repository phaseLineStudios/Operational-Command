# TriggerVM::_values_for Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 85–91)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array
```

- **names**: Compiled names.
- **ctx**: becomes constants accessible in the expression.
- **Return Value**: Array of inputs.

## Description

Creates inputs from context.

## Source

```gdscript
func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array:
	var vals: Array = []
	for n in names:
		vals.append(ctx.get(n))
	return vals
```
