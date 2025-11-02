# TTSService::_get_model_path Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 161–174)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func _get_model_path(mdl: Model) -> Dictionary
```

- **model**: a Model enum identifier.
- **Return Value**: Path to model or empty string for unknown.

## Description

Helper: Get path of selected model.

## Source

```gdscript
func _get_model_path(mdl: Model) -> Dictionary:
	if mdl == Model.EN_US_MEDIUM_RYAN:
		return {
			"model": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx",
			"config": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx.json",
		}
	elif mdl == Model.EN_US_MEDIUM_NORMAN:
		return {
			"model": VOICES_PATH + "/medium-en-us/ryan/en_US-norman-medium.onnx",
			"config": VOICES_PATH + "/medium-en-us/ryan/en_US-norman-medium.onnx.json",
		}
	return {}
```
