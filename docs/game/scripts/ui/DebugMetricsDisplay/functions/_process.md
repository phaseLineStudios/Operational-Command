# DebugMetricsDisplay::_process Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 405–543)</br>
*Belongs to:* [DebugMetricsDisplay](../../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _process(_delta: float) -> void
```

## Source

```gdscript
func _process(_delta: float) -> void:
	if visible:
		fps_graph.queue_redraw()
		total_graph.queue_redraw()
		cpu_graph.queue_redraw()
		gpu_graph.queue_redraw()

		var frametime := (Time.get_ticks_usec() - last_tick) * 0.001

		frame_history_total.push_back(frametime)
		if frame_history_total.size() > HISTORY_NUM_FRAMES:
			frame_history_total.pop_front()

		frametime_avg = frame_history_total.reduce(sum_func) / frame_history_total.size()
		frame_history_total_avg.text = str(frametime_avg).pad_decimals(2)
		frame_history_total_avg.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_min: float = frame_history_total.min()
		frame_history_total_min.text = str(frametime_min).pad_decimals(2)
		frame_history_total_min.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_min, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_max: float = frame_history_total.max()
		frame_history_total_max.text = str(frametime_max).pad_decimals(2)
		frame_history_total_max.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_max, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		frame_history_total_last.text = str(frametime).pad_decimals(2)
		frame_history_total_last.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var viewport_rid := get_viewport().get_viewport_rid()
		var frametime_cpu := (
			RenderingServer.viewport_get_measured_render_time_cpu(viewport_rid)
			+ RenderingServer.get_frame_setup_time_cpu()
		)
		frame_history_cpu.push_back(frametime_cpu)
		if frame_history_cpu.size() > HISTORY_NUM_FRAMES:
			frame_history_cpu.pop_front()

		frametime_cpu_avg = frame_history_cpu.reduce(sum_func) / frame_history_cpu.size()
		frame_history_cpu_avg.text = str(frametime_cpu_avg).pad_decimals(2)
		frame_history_cpu_avg.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_cpu_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_cpu_min: float = frame_history_cpu.min()
		frame_history_cpu_min.text = str(frametime_cpu_min).pad_decimals(2)
		frame_history_cpu_min.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_cpu_min, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_cpu_max: float = frame_history_cpu.max()
		frame_history_cpu_max.text = str(frametime_cpu_max).pad_decimals(2)
		frame_history_cpu_max.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_cpu_max, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		frame_history_cpu_last.text = str(frametime_cpu).pad_decimals(2)
		frame_history_cpu_last.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_cpu, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_gpu := RenderingServer.viewport_get_measured_render_time_gpu(viewport_rid)
		frame_history_gpu.push_back(frametime_gpu)
		if frame_history_gpu.size() > HISTORY_NUM_FRAMES:
			frame_history_gpu.pop_front()

		frametime_gpu_avg = frame_history_gpu.reduce(sum_func) / frame_history_gpu.size()
		frame_history_gpu_avg.text = str(frametime_gpu_avg).pad_decimals(2)
		frame_history_gpu_avg.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_gpu_avg, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_gpu_min: float = frame_history_gpu.min()
		frame_history_gpu_min.text = str(frametime_gpu_min).pad_decimals(2)
		frame_history_gpu_min.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_gpu_min, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		var frametime_gpu_max: float = frame_history_gpu.max()
		frame_history_gpu_max.text = str(frametime_gpu_max).pad_decimals(2)
		frame_history_gpu_max.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_gpu_max, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		frame_history_gpu_last.text = str(frametime_gpu).pad_decimals(2)
		frame_history_gpu_last.modulate = frame_time_gradient.sample(
			remap(1000.0 / frametime_gpu, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)

		frames_per_second = 1000.0 / frametime_avg
		fps_history.push_back(frames_per_second)
		if fps_history.size() > HISTORY_NUM_FRAMES:
			fps_history.pop_front()

		fps.text = str(floor(frames_per_second)) + " FPS"
		var frame_time_color := frame_time_gradient.sample(
			remap(frames_per_second, GRAPH_MIN_FPS, GRAPH_MAX_FPS, 0.0, 1.0)
		)
		fps.modulate = frame_time_color

		frame_time.text = str(frametime).pad_decimals(2) + " mspf"
		frame_time.modulate = frame_time_color

		var vsync_string := ""
		match DisplayServer.window_get_vsync_mode():
			DisplayServer.VSYNC_ENABLED:
				vsync_string = "V-Sync"
			DisplayServer.VSYNC_ADAPTIVE:
				vsync_string = "Adaptive V-Sync"
			DisplayServer.VSYNC_MAILBOX:
				vsync_string = "Mailbox V-Sync"

		if Engine.max_fps > 0 or OS.low_processor_usage_mode:
			var low_processor_max_fps := roundi(1000000.0 / OS.low_processor_usage_mode_sleep_usec)
			var fps_cap := low_processor_max_fps
			if Engine.max_fps > 0:
				fps_cap = mini(Engine.max_fps, low_processor_max_fps)
			frame_time.text += " (cap: " + str(fps_cap) + " FPS"

			if not vsync_string.is_empty():
				frame_time.text += " + " + vsync_string

			frame_time.text += ")"
		else:
			if not vsync_string.is_empty():
				frame_time.text += " (" + vsync_string + ")"

		frame_number.text = "Frame: " + str(Engine.get_frames_drawn())

	last_tick = Time.get_ticks_usec()
```
