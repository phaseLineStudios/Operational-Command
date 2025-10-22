class_name ScenarioDrawingStroke
extends ScenarioDrawing
## Freehand polyline stored in world meters.

## Stroke color (RGBA).
@export var color: Color = Color.WHITE
## Stroke width in pixels (screen-space).
@export var width_px: float = 3.0
## Opacity multiplier [0..1].
@export_range(0.0, 1.0, 0.01) var opacity: float = 1.0
## World points (meters).
@export var points_m: PackedVector2Array = []

## Serialize stroke.
## [return] Dictionary.
func serialize() -> Dictionary:
	var pts: Array = []
	for p in points_m:
		pts.append(ContentDB.v2(p))
	var out := serialize_base()
	out.merge({
		"type": "stroke",
		"color": color.to_html(true),
		"width_px": width_px,
		"opacity": opacity,
		"points": pts,
	})
	return out

## Deserialize stroke.
## [param d] Dictionary.
## [return] ScenarioDrawingStroke.
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
