# TriggerVM::_split_lines Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 106–115)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _split_lines(src: String) -> PackedStringArray
```

- **src**: Source string.
- **Return Value**: PackedStringArray of code lines.

## Description

Split source by lines.

## Source

```gdscript
func _split_lines(src: String) -> PackedStringArray:
	var work := src.replace("\r", "\n").split("\n", false)
	var out := PackedStringArray()
	for s in work:
		var parts := s.split(";", false)
		for p in parts:
			var t := p.strip_edges()
			if t != "":
				out.append(t)
	return out
```
