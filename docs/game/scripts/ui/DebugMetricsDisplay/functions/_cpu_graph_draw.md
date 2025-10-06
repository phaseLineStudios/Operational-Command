# DebugMetricsDisplay::_cpu_graph_draw Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 359–381)</br>
*Belongs to:* [DebugMetricsDisplay](../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _cpu_graph_draw() -> void
```

## Source

```gdscript
func _cpu_graph_draw() -> void:
	var cpu_polyline := PackedVector2Array()
	cpu_polyline.resize(HISTORY_NUM_FRAMES)
	for cpu_index in frame_history_cpu.size():
		cpu_polyline[cpu_index] = Vector2(
			remap(cpu_index, 0, frame_history_cpu.size(), 0, GRAPH_SIZE.x),
			remap(
				clampf(frame_history_cpu[cpu_index], GRAPH_MIN_FPS, GRAPH_MAX_FPS),
				GRAPH_MIN_FPS,
				GRAPH_MAX_FPS,
				GRAPH_SIZE.y,
				0.0
			)
		)
	cpu_graph.draw_polyline(
		cpu_polyline,
		frame_time_gradient.sample(
			remap(1000.0 / frametime_cpu_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		),
		1.0
	)
```
