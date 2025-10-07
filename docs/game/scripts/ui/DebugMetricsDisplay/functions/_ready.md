# DebugMetricsDisplay::_ready Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 88–120)</br>
*Belongs to:* [DebugMetricsDisplay](../../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	fps_graph.draw.connect(_fps_graph_draw)
	total_graph.draw.connect(_total_graph_draw)
	cpu_graph.draw.connect(_cpu_graph_draw)
	gpu_graph.draw.connect(_gpu_graph_draw)

	fps_history.resize(HISTORY_NUM_FRAMES)
	frame_history_total.resize(HISTORY_NUM_FRAMES)
	frame_history_cpu.resize(HISTORY_NUM_FRAMES)
	frame_history_gpu.resize(HISTORY_NUM_FRAMES)

	frame_time_gradient.set_color(0, Color8(239, 68, 68))
	frame_time_gradient.set_color(1, Color8(56, 189, 248))
	frame_time_gradient.add_point(0.3333, Color8(250, 204, 21))
	frame_time_gradient.add_point(0.6667, Color8(128, 226, 95))

	get_viewport().size_changed.connect(update_settings_label)

	information.text = "Loading hardware information...\n\n "
	settings.text = "Loading project information..."
	thread.start(
		func():
			if Engine.get_version_info()["hex"] >= 0x040100:
				Callable(Thread, "set_thread_safety_checks_enabled").call(false)

			RenderingServer.viewport_set_measure_render_time(
				get_viewport().get_viewport_rid(), true
			)
			update_information_label()
			update_settings_label()
	)
```
