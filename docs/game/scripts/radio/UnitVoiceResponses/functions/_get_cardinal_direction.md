# UnitVoiceResponses::_get_cardinal_direction Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 356–387)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _get_cardinal_direction(from: Vector2, to: Vector2) -> String
```

- **from**: Start position.
- **to**: End position.
- **Return Value**: Cardinal direction string (e.g., "north", "northeast").

## Description

Get cardinal direction from one position to another.

## Source

```gdscript
func _get_cardinal_direction(from: Vector2, to: Vector2) -> String:
	var delta := to - from
	if delta.length() < 1.0:
		return "current position"

	var angle := delta.angle()
	var degrees := rad_to_deg(angle)

	# Normalize to 0-360
	while degrees < 0:
		degrees += 360
	while degrees >= 360:
		degrees -= 360

	# Map to cardinal/intercardinal directions
	# 0° is east, 90° is south, 180° is west, 270° is north
	if degrees < 22.5 or degrees >= 337.5:
		return "east"
	elif degrees < 67.5:
		return "southeast"
	elif degrees < 112.5:
		return "south"
	elif degrees < 157.5:
		return "southwest"
	elif degrees < 202.5:
		return "west"
	elif degrees < 247.5:
		return "northwest"
	elif degrees < 292.5:
		return "north"
	else:
		return "northeast"
```
