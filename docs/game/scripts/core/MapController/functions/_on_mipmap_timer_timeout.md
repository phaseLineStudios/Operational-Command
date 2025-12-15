# MapController::_on_mipmap_timer_timeout Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 293–297)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_mipmap_timer_timeout() -> void
```

## Source

```gdscript
func _on_mipmap_timer_timeout() -> void:
	_mipmap_timer = null
	_run_mipmap_update_async(_mipmap_gen)
```
