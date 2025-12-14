# CombatSoundController::_pick_random_stream Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 175–181)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream
```

## Description

Returns a random AudioStream from list or null if empty.

## Source

```gdscript
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream:
	if list.is_empty():
		return null
	if list.size() == 1:
		return list[0]
	var index := _rng.randi_range(0, list.size() - 1)
	return list[index]
```
