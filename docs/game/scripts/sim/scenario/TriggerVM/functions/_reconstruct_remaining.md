# TriggerVM::_reconstruct_remaining Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 546–560)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _reconstruct_remaining(lines: Array, start_idx: int) -> String
```

## Description

Reconstruct remaining source code from line array.

## Source

```gdscript
func _reconstruct_remaining(lines: Array, start_idx: int) -> String:
	if start_idx >= lines.size():
		return ""

	var result := PackedStringArray()
	for i in range(start_idx, lines.size()):
		var line_info: Dictionary = lines[i]
		var indent_str := ""
		for j in line_info.indent:
			indent_str += "    "  # 4 spaces per indent level
		result.append(indent_str + line_info.code)

	return "\n".join(result)
```
