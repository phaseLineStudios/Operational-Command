# DebugMetricsDisplay::_on_visibility_changed Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 544–560)</br>
*Belongs to:* [DebugMetricsDisplay](../../DebugMetricsDisplay.md)

**Signature**

```gdscript
func _on_visibility_changed() -> void
```

## Source

```gdscript
func _on_visibility_changed() -> void:
	if visible:
		var frametime_last := (Time.get_ticks_usec() - last_tick) * 0.001
		fps_history.resize(HISTORY_NUM_FRAMES)
		fps_history.fill(1000.0 / frametime_last)
		frame_history_total.resize(HISTORY_NUM_FRAMES)
		frame_history_total.fill(frametime_last)
		frame_history_cpu.resize(HISTORY_NUM_FRAMES)
		var viewport_rid := get_viewport().get_viewport_rid()
		frame_history_cpu.fill(
			(
				RenderingServer.viewport_get_measured_render_time_cpu(viewport_rid)
				+ RenderingServer.get_frame_setup_time_cpu()
			)
		)
		frame_history_gpu.resize(HISTORY_NUM_FRAMES)
		frame_history_gpu.fill(RenderingServer.viewport_get_measured_render_time_gpu(viewport_rid))
```
