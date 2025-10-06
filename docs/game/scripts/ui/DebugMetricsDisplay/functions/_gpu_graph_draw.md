# DebugMetricsDisplay::_gpu_graph_draw Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 382–404)</br>
*Belongs to:* [DebugMetricsDisplay](../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _gpu_graph_draw() -> void
```

## Source

```gdscript
func _gpu_graph_draw() -> void:
	var gpu_polyline := PackedVector2Array()
	gpu_polyline.resize(HISTORY_NUM_FRAMES)
	for gpu_index in frame_history_gpu.size():
		gpu_polyline[gpu_index] = Vector2(
			remap(gpu_index, 0, frame_history_gpu.size(), 0, GRAPH_SIZE.x),
			remap(
				clampf(frame_history_gpu[gpu_index], GRAPH_MIN_FPS, GRAPH_MAX_FPS),
				GRAPH_MIN_FPS,
				GRAPH_MAX_FPS,
				GRAPH_SIZE.y,
				0.0
			)
		)
	gpu_graph.draw_polyline(
		gpu_polyline,
		frame_time_gradient.sample(
			remap(1000.0 / frametime_gpu_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		),
		1.0
	)
```
