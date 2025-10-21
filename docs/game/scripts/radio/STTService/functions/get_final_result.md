# STTService::get_final_result Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 104–107)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func get_final_result() -> String
```

## Description

Returns the last final result from the recognizer (non-blocking).

## Source

```gdscript
func get_final_result() -> String:
	return _stt.result()
```
