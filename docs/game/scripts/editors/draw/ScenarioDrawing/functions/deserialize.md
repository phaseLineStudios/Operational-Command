# ScenarioDrawing::deserialize Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawing.gd` (lines 38–46)</br>
*Belongs to:* [ScenarioDrawing](../../ScenarioDrawing.md)

**Signature**

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawing
```

- **d**: Serialized object.
- **Return Value**: ScenarioDrawing or null.

## Description

Factory from Dictionary.

## Source

```gdscript
static func deserialize(d: Dictionary) -> ScenarioDrawing:
	var t := String(d.get("type", ""))
	match t:
		"stroke":
			return ScenarioDrawingStroke.deserialize(d)
		"stamp":
			return ScenarioDrawingStamp.deserialize(d)
		_:
			return null
```
