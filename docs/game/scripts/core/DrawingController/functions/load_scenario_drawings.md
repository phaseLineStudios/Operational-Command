# DrawingController::load_scenario_drawings Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 345–382)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func load_scenario_drawings(scenario: ScenarioData, terrain_renderer: TerrainRender) -> void
```

- **scenario**: ScenarioData with drawings to render.
- **terrain_renderer**: TerrainRender for coordinate conversion.

## Description

Load scenario drawings and render them.

## Source

```gdscript
func load_scenario_drawings(scenario: ScenarioData, terrain_renderer: TerrainRender) -> void:
	if scenario == null or terrain_renderer == null:
		LogService.warning(
			"load_scenario_drawings: scenario or terrain_renderer is null", "DrawingController.gd"
		)
		return

	_terrain_render = terrain_renderer

	_scenario_strokes.clear()

	var stamps: Array[ScenarioDrawingStamp] = []

	for drawing in scenario.drawings:
		if drawing == null:
			continue

		if drawing is ScenarioDrawingStroke and drawing.visible:
			var stroke := _convert_scenario_stroke(drawing)
			if stroke != null and not stroke.is_empty():
				_scenario_strokes.append(stroke)
			else:
				LogService.warning(
					"Failed to convert stroke %s" % drawing.id, "DrawingController.gd"
				)
		elif drawing is ScenarioDrawingStamp and drawing.visible:
			stamps.append(drawing)

	if terrain_renderer.stamp_layer:
		terrain_renderer.stamp_layer.load_stamps(stamps)
	else:
		LogService.warning(
			"Cannot load stamps: terrain_renderer.stamp_layer is null", "DrawingController.gd"
		)

	_update_drawing_mesh()
```
