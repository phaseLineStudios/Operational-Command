# STTService::_join_non_empty Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 176–181)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func _join_non_empty(a: String, b: String) -> String
```

## Description

Join a and b with a single space if both are non-empty.

## Source

```gdscript
func _join_non_empty(a: String, b: String) -> String:
	if a.length() == 0:
		return b
	if b.length() == 0:
		return a
	return a + ("" if a.ends_with(" ") else " ") + b
```
