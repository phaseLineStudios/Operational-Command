# TriggerAPI::rect2 Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 541–544)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func rect2(x: float, y: float, width: float, height: float) -> Rect2
```

- **x**: X position
- **y**: Y position
- **width**: Width
- **height**: Height
- **Return Value**: Rect2 with given position and size

## Description

Create a Rect2 from position and size.

## Source

```gdscript
func rect2(x: float, y: float, width: float, height: float) -> Rect2:
	return Rect2(x, y, width, height)
```
