class_name ScenarioDrawingStamp
extends ScenarioDrawing
## Texture stamp placed at world position.

## Texture path (res://).
@export_file("*.png", "*.jpg", "*.webp") var texture_path: String = ""
## Tint color.
@export var modulate: Color = Color.WHITE
## Opacity multiplier [0..1].
@export_range(0.0, 1.0, 0.01) var opacity: float = 1.0
## Center position in meters.
@export var position_m: Vector2 = Vector2.ZERO
## Screen-space uniform scale.
@export_range(0.05, 10.0, 0.01) var scale: float = 1.0
## Rotation in degrees (clockwise).
@export_range(-360.0, 360.0, 0.1) var rotation_deg: float = 0.0


## Serialize stamp.
## [return] Dictionary.
func serialize() -> Dictionary:
	var out := serialize_base()
	(
		out
		. merge(
			{
				"type": "stamp",
				"texture_path": texture_path,
				"modulate": modulate.to_html(true),
				"opacity": opacity,
				"position_m": ContentDB.v2(position_m),
				"scale": scale,
				"rotation_deg": rotation_deg,
			}
		)
	)
	return out


## Deserialize stamp.
## [param d] Dictionary.
## [return] ScenarioDrawingStamp.
static func deserialize(d: Dictionary) -> ScenarioDrawingStamp:
	var s := ScenarioDrawingStamp.new()
	s.deserialize_base(d)
	s.texture_path = String(d.get("texture_path", ""))
	s.modulate = Color(String(d.get("modulate", "#ffffffff")))
	s.opacity = float(d.get("opacity", s.opacity))
	s.position_m = ContentDB.v2_from(d.get("position_m"))
	s.scale = float(d.get("scale", s.scale))
	s.rotation_deg = float(d.get("rotation_deg", s.rotation_deg))
	return s
