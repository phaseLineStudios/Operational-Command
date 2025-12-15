# Game::_on_window_size_changed Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 74–85)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func _on_window_size_changed() -> void
```

## Source

```gdscript
func _on_window_size_changed() -> void:
	# Coalesce rapid size changes (fullscreen transitions can emit many events).
	if _video_perf_timer != null:
		return
	_video_perf_timer = get_tree().create_timer(0.05)
	_video_perf_timer.timeout.connect(
		func():
			_video_perf_timer = null
			_apply_video_perf_settings()
	)
```
