# TriggerVM::_line_needs_continuation Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 232–268)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _line_needs_continuation(line: String) -> bool
```

- **line**: Line to check.
- **Return Value**: True if the line needs continuation.

## Description

Check if a line ends with a token that requires continuation on the next line.

## Source

```gdscript
func _line_needs_continuation(line: String) -> bool:
	if line == "":
		return false

	# Binary operators that require a right-hand side
	var continuation_tokens := [
		"and",
		"or",
		"not",
		"+",
		"-",
		"*",
		"/",
		"%",
		"==",
		"!=",
		"<",
		">",
		"<=",
		">=",
		"in",
		"is",
		".",
		",",
		"=",
	]

	for token in continuation_tokens:
		if line.ends_with(token):
			return true
		# Also check for token followed by whitespace (already stripped)
		if line.ends_with(token + " "):
			return true

	return false
```
