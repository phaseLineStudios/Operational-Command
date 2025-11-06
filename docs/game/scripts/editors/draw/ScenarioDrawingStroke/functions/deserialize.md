# ScenarioDrawingStroke::deserialize Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawingStroke.gd` (lines 40–51)</br>
*Belongs to:* [ScenarioDrawingStroke](../../ScenarioDrawingStroke.md)

**Signature**

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawingStroke
```

- **d**: Dictionary.
- **Return Value**: ScenarioDrawingStroke.

## Description

Deserialize stroke.

## Source

```gdscript
static func deserialize(d: Dictionary) -> ScenarioDrawingStroke:
	var s := ScenarioDrawingStroke.new()
	s.deserialize_base(d)
	s.color = Color(String(d.get("color", "#ffffffff")))
	s.width_px = float(d.get("width_px", s.width_px))
	s.opacity = float(d.get("opacity", s.opacity))
	var pts: Array = d.get("points", [])
	var acc := PackedVector2Array()
	for it in pts:
		acc.push_back(ContentDB.v2_from(it))
	s.points_m = acc
	return s
```
