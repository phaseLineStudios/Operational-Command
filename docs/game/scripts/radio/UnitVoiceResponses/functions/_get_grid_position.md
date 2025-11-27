# UnitVoiceResponses::_get_grid_position Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 331–337)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _get_grid_position(pos_m: Vector2) -> String
```

- **pos_m**: Position in meters.
- **Return Value**: Grid coordinate string (e.g. "123456") or empty if unavailable.

## Description

Get grid coordinate for a position.

## Source

```gdscript
func _get_grid_position(pos_m: Vector2) -> String:
	if terrain_render:
		var grid_str := " ".join(terrain_render.pos_to_grid(pos_m).split(""))
		return grid_str
	return ""
```
