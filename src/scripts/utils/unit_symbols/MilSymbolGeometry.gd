class_name MilSymbolGeometry
extends RefCounted
## Base geometry definitions for military symbol frames
## Defines the frame shapes for different affiliations and domains

## Domain types (determines base shape)
enum Domain { GROUND, AIR, SEA, SPACE, SUBSURFACE }


## Get frame points for ground units based on affiliation
## Returns an array of Vector2 points in 200x200 coordinate space
static func get_ground_frame(affiliation: MilSymbolConfig.Affiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbolConfig.Affiliation.FRIEND:
			# Rectangle
			return [Vector2(25, 50), Vector2(175, 50), Vector2(175, 150), Vector2(25, 150)]
		MilSymbolConfig.Affiliation.HOSTILE:
			# Diamond
			return [Vector2(100, 28), Vector2(172, 100), Vector2(100, 172), Vector2(28, 100)]
		MilSymbolConfig.Affiliation.NEUTRAL:
			# Square
			return [Vector2(45, 45), Vector2(155, 45), Vector2(155, 155), Vector2(45, 155)]
		MilSymbolConfig.Affiliation.UNKNOWN:
			# Clover (approximated with circle for simplicity)
			return []  # Will use draw_circle instead
	return []


## Get frame points for air units based on affiliation
static func get_air_frame(affiliation: MilSymbolConfig.Affiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbolConfig.Affiliation.FRIEND:
			# Curved arc (approximated with segments)
			return _create_arc_points(Vector2(100, 100), 60.0, 180.0, 0.0, 32)
		MilSymbolConfig.Affiliation.HOSTILE:
			# Chevron
			return [
				Vector2(45, 150),
				Vector2(45, 70),
				Vector2(100, 20),
				Vector2(155, 70),
				Vector2(155, 150)
			]
		MilSymbolConfig.Affiliation.NEUTRAL:
			# Flat top rectangle
			return [Vector2(45, 150), Vector2(45, 30), Vector2(155, 30), Vector2(155, 150)]
		MilSymbolConfig.Affiliation.UNKNOWN:
			# Rounded clover
			return []
	return []


## Get frame points for sea units based on affiliation
static func get_sea_frame(affiliation: MilSymbolConfig.Affiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbolConfig.Affiliation.FRIEND:
			# Circle (will use draw_circle)
			return []
		MilSymbolConfig.Affiliation.HOSTILE:
			# Diamond
			return get_ground_frame(MilSymbolConfig.Affiliation.HOSTILE)
		MilSymbolConfig.Affiliation.NEUTRAL:
			# Square
			return get_ground_frame(MilSymbolConfig.Affiliation.NEUTRAL)
		MilSymbolConfig.Affiliation.UNKNOWN:
			# Clover
			return []
	return []


## Get bounding box for a frame (in 200x200 coordinate space)
static func get_frame_bounds(domain: Domain, affiliation: MilSymbolConfig.Affiliation) -> Rect2:
	match domain:
		Domain.GROUND:
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return Rect2(25, 50, 150, 100)
				MilSymbolConfig.Affiliation.HOSTILE:
					return Rect2(28, 28, 144, 144)
				MilSymbolConfig.Affiliation.NEUTRAL:
					return Rect2(45, 45, 110, 110)
				MilSymbolConfig.Affiliation.UNKNOWN:
					return Rect2(30, 30, 140, 140)
		Domain.AIR:
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return Rect2(45, 30, 110, 120)
				MilSymbolConfig.Affiliation.HOSTILE:
					return Rect2(45, 20, 110, 130)
				_:
					return Rect2(45, 30, 110, 120)
		Domain.SEA:
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return Rect2(40, 40, 120, 120)
				_:
					return Rect2(45, 45, 110, 110)
		_:
			return Rect2(25, 25, 150, 150)
	return Rect2(25, 25, 150, 150)


## Check if frame should use circle drawing
static func is_circle_frame(domain: Domain, affiliation: MilSymbolConfig.Affiliation) -> bool:
	if domain == Domain.SEA and affiliation == MilSymbolConfig.Affiliation.FRIEND:
		return true
	if affiliation == MilSymbolConfig.Affiliation.UNKNOWN:
		return true  # Simplified clover as circle
	return false


## Get circle parameters [center_x, center_y, radius]
static func get_circle_params(domain: Domain, affiliation: MilSymbolConfig.Affiliation) -> Array:
	if domain == Domain.SEA and affiliation == MilSymbolConfig.Affiliation.FRIEND:
		return [Vector2(100, 100), 60.0]
	if affiliation == MilSymbolConfig.Affiliation.UNKNOWN:
		return [Vector2(100, 100), 70.0]
	return [Vector2(100, 100), 50.0]


## Create arc points for curved shapes
static func _create_arc_points(
	center: Vector2, radius: float, start_angle: float, end_angle: float, segments: int = 32
) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var angle_step: float = (end_angle - start_angle) / segments

	for i in range(segments + 1):
		var angle: float = deg_to_rad(start_angle + i * angle_step)
		var x: float = center.x + radius * cos(angle)
		var y: float = center.y + radius * sin(angle)
		points.append(Vector2(x, y))

	return points
