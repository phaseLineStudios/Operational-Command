# TerrainEditor::_on_brush_overlay_gui_input Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 342–358)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _on_brush_overlay_gui_input(event)
```

## Description

Input handler for terrainview Viewport

## Source

```gdscript
func _on_brush_overlay_gui_input(event):
	if event is InputEventMouseMotion:
		var mp = map_to_terrain(event.position)
		var grid := terrain_render.pos_to_grid(mp)
		mouse_position_l.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]

	if event is InputEventMouseMotion && active_tool:
		active_tool.on_mouse_inside(_inside_brush_overlay)
		if not _inside_brush_overlay:
			return

		active_tool.update_preview_at_overlay(brush_overlay, event.position)

	if active_tool and active_tool.handle_view_input(event):
		return
```
