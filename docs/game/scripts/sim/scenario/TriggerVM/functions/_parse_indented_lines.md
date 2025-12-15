# TriggerVM::_parse_indented_lines Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 563–602)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _parse_indented_lines(src: String) -> Array
```

## Description

Parse source into lines with indentation info.
Returns Array of {indent: int, code: String}.

## Source

```gdscript
func _parse_indented_lines(src: String) -> Array:
	var result := []
	var raw_lines := src.replace("\r\n", "\n").replace("\r", "\n").split("\n")

	for raw_line in raw_lines:
		# Calculate indentation level (assume 4 spaces per level)
		var indent_level := 0
		var i := 0
		while i < raw_line.length():
			if raw_line[i] == "\t":
				indent_level += 1
				i += 1
			elif raw_line[i] == " ":
				var spaces := 0
				while i < raw_line.length() and raw_line[i] == " ":
					spaces += 1
					i += 1
				indent_level += int(spaces / 4.0)
			else:
				break

		var code := raw_line.strip_edges()

		# Skip empty lines
		if code == "":
			continue

		# Handle semicolon-separated statements on same line
		if ";" in code:
			var statements := code.split(";")
			for stmt in statements:
				var stmt_clean := stmt.strip_edges()
				if stmt_clean != "":
					result.append({"indent": indent_level, "code": stmt_clean})
		else:
			result.append({"indent": indent_level, "code": code})

	return result
```
