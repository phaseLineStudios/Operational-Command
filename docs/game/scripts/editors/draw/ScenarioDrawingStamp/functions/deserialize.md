# ScenarioDrawingStamp::deserialize Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawingStamp.gd` (lines 46–56)</br>
*Belongs to:* [ScenarioDrawingStamp](../../ScenarioDrawingStamp.md)

**Signature**

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawingStamp
```

- **d**: Dictionary.
- **Return Value**: ScenarioDrawingStamp.

## Description

Deserialize stamp.

## Source

```gdscript
static func deserialize(d: Dictionary) -> ScenarioDrawingStamp:
	var s := ScenarioDrawingStamp.new()
	s.deserialize_base(d)
	s.texture_path = String(d.get("texture_path", ""))
	s.modulate = Color(String(d.get("modulate", "#ffffffff")))
	s.opacity = float(d.get("opacity", s.opacity))
	s.position_m = ContentDB.v2_from(d.get("position_m"))
	s.scale = float(d.get("scale", s.scale))
	s.rotation_deg = float(d.get("rotation_deg", s.rotation_deg))
	s.label = String(d.get("label", ""))
	return s
```
