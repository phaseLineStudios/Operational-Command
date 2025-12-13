# TTSService::_get_platform_binary Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 201–212)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _get_platform_binary() -> String
```

- **Return Value**: path to platform specific binary or empty string for unknown.

## Description

Helper: Get platform specific path for piper binary.

## Source

```gdscript
func _get_platform_binary() -> String:
	match OS.get_name():
		"Windows":
			return BASE_PATH + "/win64/piper.exe"
		"Linux":
			return BASE_PATH + "/linux/piper"
		"macOS":
			return BASE_PATH + "/macos/piper"
		_:
			return ""
```
