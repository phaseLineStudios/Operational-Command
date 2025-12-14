# TTSService::_read_sample_rate Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 188–198)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _read_sample_rate(cfg_res_path: String, fallback: int) -> int
```

- **cfg_res_path**: res:// path to model config.
- **fallback**: Fallback sample rate.
- **Return Value**: Model sample rate.

## Description

Helper: Read sample rate from model config.

## Source

```gdscript
func _read_sample_rate(cfg_res_path: String, fallback: int) -> int:
	var sr := fallback
	var path := _abs_path(cfg_res_path)
	if FileAccess.file_exists(path):
		var s := FileAccess.get_file_as_string(path)
		var j: Dictionary = JSON.parse_string(s)
		if typeof(j) == TYPE_DICTIONARY and j.has("sample_rate"):
			sr = int(j["sample_rate"])
	return sr
```
