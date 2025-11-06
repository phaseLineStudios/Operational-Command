# EngineerController::_place_bridge Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 197–256)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _place_bridge(target_pos: Vector2) -> void
```

## Description

Place a bridge at the target position

## Source

```gdscript
func _place_bridge(target_pos: Vector2) -> void:
	if not terrain_renderer or not terrain_renderer.data:
		LogService.warning("Cannot place bridge: no terrain data bound", "EngineerController")
		return

	var water_feature: Variant = _find_nearest_water(target_pos)
	if water_feature == null:
		LogService.warning(
			"No water found near %s for bridge placement" % target_pos, "EngineerController"
		)
		return

	var bridge_endpoints := _calculate_bridge_span(water_feature, target_pos)
	if bridge_endpoints.is_empty():
		LogService.warning("Could not calculate bridge span", "EngineerController")
		return

	var start_pos: Vector2 = bridge_endpoints[0]
	var end_pos: Vector2 = bridge_endpoints[1]

	var bridge_brush: TerrainBrush = load("res://assets/terrain_brushes/bridge.tres")
	if not bridge_brush:
		bridge_brush = load("res://assets/terrain_brushes/primary_road.tres")
	if not bridge_brush:
		LogService.warning(
			"Bridge brush not found, bridge will not be visible", "EngineerController"
		)
		return

	var bridge_direction := (end_pos - start_pos).normalized()
	var perpendicular := Vector2(-bridge_direction.y, bridge_direction.x)

	var num_lines := 3
	var spacing := 5.0
	var half_width := (num_lines - 1) * spacing / 2.0

	for i in range(num_lines):
		var offset := (i - (num_lines - 1) / 2.0) * spacing
		var offset_start := start_pos + perpendicular * offset
		var offset_end := end_pos + perpendicular * offset

		var bridge_line := {
			"brush": bridge_brush,
			"points": PackedVector2Array([offset_start, offset_end]),
			"closed": false,
			"width_px": 3.0
		}
		terrain_renderer.data.add_line(bridge_line)

	_rebuild_pathfinding()

	LogService.info(
		(
			"Bridge placed from %s to %s (span: %.1fm, width: %.1fm)"
			% [start_pos, end_pos, start_pos.distance_to(end_pos), half_width * 2.0]
		),
		"EngineerController"
	)
```
