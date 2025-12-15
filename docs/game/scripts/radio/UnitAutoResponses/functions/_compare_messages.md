# UnitAutoResponses::_compare_messages Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 337–342)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _compare_messages(a: VoiceMessage, b: VoiceMessage) -> bool
```

## Description

Compare messages for priority sorting (higher priority first).

## Source

```gdscript
func _compare_messages(a: VoiceMessage, b: VoiceMessage) -> bool:
	if a.priority != b.priority:
		return a.priority > b.priority
	return a.timestamp < b.timestamp
```
