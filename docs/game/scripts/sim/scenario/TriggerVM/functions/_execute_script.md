# TriggerVM::_execute_script Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 273–278)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _execute_script(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void
```

- **src**: Source code (comments already stripped).
- **ctx**: Context dictionary.
- **debug_info**: Optional debug info for error messages.

## Description

Execute a script with control flow support (if/elif/else, var, assignments).

## Source

```gdscript
func _execute_script(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void:
	var lines := _parse_indented_lines(src)
	var local_vars := {}  # Track local variables
	_execute_block(lines, 0, ctx, local_vars, debug_info)
```
