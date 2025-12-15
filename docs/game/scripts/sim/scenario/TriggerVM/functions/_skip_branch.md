# TriggerVM::_skip_branch Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 405–414)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _skip_branch(lines: Array, start_idx: int, base_indent: int) -> int
```

## Description

Skip a branch (the indented block after if/elif/else).

## Source

```gdscript
func _skip_branch(lines: Array, start_idx: int, base_indent: int) -> int:
	var i := start_idx
	while i < lines.size():
		var indent: int = lines[i].indent
		if indent <= base_indent:
			return i
		i += 1
	return i
```
