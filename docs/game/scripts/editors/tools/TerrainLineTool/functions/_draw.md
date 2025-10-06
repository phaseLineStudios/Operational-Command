# TerrainLineTool::_draw Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 424–443)</br>
*Belongs to:* [TerrainLineTool](../TerrainLineTool.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
	func _draw() -> void:
		if tool == null or tool._edit_idx < 0:
			return
		var pts := tool._current_points()
		if pts.is_empty():
			return

		for i in pts.size():
			var p_map := tool.editor.terrain_to_map(pts[i])

			draw_circle(p_map, handle_r + 2.0, Color(0, 0, 0, 0.9))
			draw_circle(p_map, handle_r, Color(1, 1, 1, 0.95))

		if tool._hover_idx >= 0 and tool._hover_idx < pts.size():
			var ph_map := tool.editor.terrain_to_map(pts[tool._hover_idx])
			draw_circle(ph_map, handle_r + 4.0, Color(1.0, 0.7, 0.2, 0.35))

		if tool._is_drag and tool._drag_idx >= 0 and tool._drag_idx < pts.size():
			var pd_map := tool.editor.terrain_to_map(pts[tool._drag_idx])
			draw_circle(pd_map, handle_r + 6.0, Color(0.2, 0.6, 1.0, 0.35))
```
