# DebugMetricsDisplay::_fps_graph_draw Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 313–335)</br>
*Belongs to:* [DebugMetricsDisplay](../../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _fps_graph_draw() -> void
```

## Source

```gdscript
func _fps_graph_draw() -> void:
	var fps_polyline := PackedVector2Array()
	fps_polyline.resize(HISTORY_NUM_FRAMES)
	for fps_index in fps_history.size():
		fps_polyline[fps_index] = Vector2(
			remap(fps_index, 0, fps_history.size(), 0, GRAPH_SIZE.x),
			remap(
				clampf(fps_history[fps_index], GRAPH_MIN_FPS, GRAPH_MAX_FPS),
				GRAPH_MIN_FPS,
				GRAPH_MAX_FPS,
				GRAPH_SIZE.y,
				0.0
			)
		)
	fps_graph.draw_polyline(
		fps_polyline,
		frame_time_gradient.sample(
			remap(frames_per_second, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		),
		1.0
	)
```
