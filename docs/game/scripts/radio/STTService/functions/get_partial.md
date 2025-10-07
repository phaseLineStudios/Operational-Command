# STTService::get_partial Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 109–112)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func get_partial() -> String
```

## Description

Returns the latest partial result from the recognizer (non-blocking).

## Source

```gdscript
func get_partial() -> String:
	return _stt.partial_result()
```
