# TTSService::_abs_path Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 238–239)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _abs_path(path: String) -> String
```

- **path**: res path to translate.
- **Return Value**: Returns absolute path.

## Description

Helper: returns absolute path

## Source

```gdscript
func _abs_path(path: String) -> String:
	return ProjectSettings.globalize_path(path)
```
