# TriggerVM::_strip_comments Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 606–653)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _strip_comments(src: String) -> String
```

- **src**: Source code.
- **Return Value**: Source code with comments removed.

## Description

Strip comments from source code whdwile preserving strings.

## Source

```gdscript
func _strip_comments(src: String) -> String:
	var result := ""
	var in_string := false
	var string_char := ""
	var i := 0

	while i < src.length():
		var c := src[i]

		# Handle string literals
		if c == '"' or c == "'":
			if not in_string:
				in_string = true
				string_char = c
				result += c
			elif c == string_char:
				# Check if escaped
				if i > 0 and src[i - 1] == "\\":
					result += c
				else:
					in_string = false
					result += c
			else:
				result += c
			i += 1
			continue

		# Skip if inside string
		if in_string:
			result += c
			i += 1
			continue

		# Check for comment
		if c == "#":
			# Skip until end of line
			while i < src.length() and src[i] != "\n":
				i += 1
			# Don't skip the newline itself, let it be added
			if i < src.length():
				result += "\n"
				i += 1
			continue

		result += c
		i += 1

	return result
```
