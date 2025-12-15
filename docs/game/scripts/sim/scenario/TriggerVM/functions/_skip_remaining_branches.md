# TriggerVM::_skip_remaining_branches Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 416–433)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _skip_remaining_branches(lines: Array, start_idx: int, base_indent: int) -> int
```

## Description

Skip remaining elif/else branches after one has been executed.

## Source

```gdscript
func _skip_remaining_branches(lines: Array, start_idx: int, base_indent: int) -> int:
	var i := start_idx
	while i < lines.size():
		var line_info: Dictionary = lines[i]
		var indent: int = line_info.indent
		var code: String = line_info.code

		if indent < base_indent:
			return i

		if indent == base_indent and (code.begins_with("elif ") or code.begins_with("else")):
			i = _skip_branch(lines, i + 1, base_indent)
		else:
			return i

	return i
```
