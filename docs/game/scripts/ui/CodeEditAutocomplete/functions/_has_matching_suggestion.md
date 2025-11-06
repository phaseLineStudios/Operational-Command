# CodeEditAutocomplete::_has_matching_suggestion Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 298–321)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _has_matching_suggestion(partial: String) -> bool
```

## Description

Check if partial word matches any suggestion.

## Source

```gdscript
func _has_matching_suggestion(partial: String) -> bool:
	if partial.is_empty():
		return false

	partial = partial.to_lower()

	# Check custom methods
	for method_name in custom_methods:
		if method_name.to_lower().begins_with(partial):
			return true

	# Check keywords
	for keyword in base_keywords:
		if keyword.to_lower().begins_with(partial):
			return true

	# Check built-in functions
	for func_name in builtin_functions:
		if func_name.to_lower().begins_with(partial):
			return true

	return false
```
