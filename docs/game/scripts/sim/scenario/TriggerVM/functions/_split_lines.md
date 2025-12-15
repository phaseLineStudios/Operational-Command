# TriggerVM::_split_lines Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 143–228)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _split_lines(src: String) -> PackedStringArray
```

- **src**: Source string.
- **Return Value**: PackedStringArray of code lines.

## Description

Split source by lines, respecting multi-line expressions.
Handles parentheses, brackets, and braces to keep multi-line calls together.

## Source

```gdscript
func _split_lines(src: String) -> PackedStringArray:
	var work := src.replace("\r", "\n")
	var out := PackedStringArray()
	var current := ""
	var paren_depth := 0
	var bracket_depth := 0
	var brace_depth := 0
	var in_string := false
	var string_char := ""
	var i := 0

	var stmt: String
	while i < work.length():
		var c := work[i]

		# Handle string literals
		if c == '"' or c == "'":
			if not in_string:
				in_string = true
				string_char = c
			elif c == string_char:
				# Check if escaped
				if i > 0 and work[i - 1] != "\\":
					in_string = false
			current += c
			i += 1
			continue

		# Skip if inside string
		if in_string:
			current += c
			i += 1
			continue

		# Track depth
		if c == "(":
			paren_depth += 1
		elif c == ")":
			paren_depth -= 1
		elif c == "[":
			bracket_depth += 1
		elif c == "]":
			bracket_depth -= 1
		elif c == "{":
			brace_depth += 1
		elif c == "}":
			brace_depth -= 1

		# Statement separator
		if c == ";" and paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
			stmt = current.strip_edges()
			if stmt != "":
				out.append(stmt)
			current = ""
			i += 1
			continue

		# Newline - only split if all depths are zero AND not continuing an operator
		if c == "\n":
			if paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
				stmt = current.strip_edges()
				# Check if line ends with a continuation operator/token
				var should_continue := _line_needs_continuation(stmt)
				if stmt != "" and not should_continue:
					out.append(stmt)
					current = ""
				else:
					# Keep the newline as a space for multi-line expressions
					current += " "
			else:
				# Keep the newline as a space for multi-line expressions
				current += " "
			i += 1
			continue

		current += c
		i += 1

	# Add remaining
	stmt = current.strip_edges()
	if stmt != "":
		out.append(stmt)

	return out
```
