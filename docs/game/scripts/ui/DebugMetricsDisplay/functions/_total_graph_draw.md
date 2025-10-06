# DebugMetricsDisplay::_total_graph_draw Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 336–358)</br>
*Belongs to:* [DebugMetricsDisplay](../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _total_graph_draw() -> void
```

## Source

```gdscript
func _total_graph_draw() -> void:
	var total_polyline := PackedVector2Array()
	total_polyline.resize(HISTORY_NUM_FRAMES)
	for total_index in frame_history_total.size():
		total_polyline[total_index] = Vector2(
			remap(total_index, 0, frame_history_total.size(), 0, GRAPH_SIZE.x),
			remap(
				clampf(frame_history_total[total_index], GRAPH_MIN_FPS, GRAPH_MAX_FPS),
				GRAPH_MIN_FPS,
				GRAPH_MAX_FPS,
				GRAPH_SIZE.y,
				0.0
			)
		)
	total_graph.draw_polyline(
		total_polyline,
		frame_time_gradient.sample(
			remap(1000.0 / frametime_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		),
		1.0
	)
```
