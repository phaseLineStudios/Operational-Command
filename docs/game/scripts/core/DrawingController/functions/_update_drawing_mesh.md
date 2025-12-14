# DrawingController::_update_drawing_mesh Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 193–222)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _update_drawing_mesh() -> void
```

## Source

```gdscript
func _update_drawing_mesh() -> void:
	var drawing_mesh: MeshInstance3D = map_mesh.get_node_or_null("DrawingMesh")
	if not drawing_mesh:
		LogService.warning("_update_drawing_mesh: drawing_mesh not found", "DrawingController.gd")
		return

	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	for stroke in _scenario_strokes:
		var points: Array = stroke.points
		var color: Color = stroke.get("color", Color.BLACK)
		_draw_stroke(surface_tool, points, Tool.NONE, false, color)

	for stroke in _strokes:
		var tool: Tool = stroke.tool
		var points: Array = stroke.points
		_draw_stroke(surface_tool, points, tool, false)

	if _is_drawing and not _current_stroke.is_empty() and _current_tool != Tool.ERASER:
		_draw_stroke(surface_tool, _current_stroke, _current_tool, true)

	if surface_tool.get_primitive_type() != -1:
		surface_tool.generate_normals()
		var array_mesh := surface_tool.commit()
		drawing_mesh.mesh = array_mesh
	else:
		drawing_mesh.mesh = null
```
