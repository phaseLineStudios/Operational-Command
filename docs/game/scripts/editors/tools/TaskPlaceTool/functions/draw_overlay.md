# TaskPlaceTool::draw_overlay Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 66–72)</br>
*Belongs to:* [TaskPlaceTool](../../TaskPlaceTool.md)

**Signature**

```gdscript
func draw_overlay(canvas: Control) -> void
```

## Source

```gdscript
func draw_overlay(canvas: Control) -> void:
	if not _hover_valid:
		return
	var p := editor.terrain_render.terrain_to_map(_hover_map_pos)
	canvas.draw_circle(p, 6.0, task.color if task else Color.CYAN)
```
