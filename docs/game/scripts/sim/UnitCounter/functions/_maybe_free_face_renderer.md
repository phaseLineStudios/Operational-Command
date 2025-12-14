# UnitCounter::_maybe_free_face_renderer Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 91–103)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _maybe_free_face_renderer() -> void
```

## Source

```gdscript
func _maybe_free_face_renderer() -> void:
	if face_renderer:
		face_renderer.render_target_update_mode = SubViewport.UPDATE_DISABLED

	if free_face_renderer_after_bake and not Engine.is_editor_hint():
		if face_renderer:
			face_renderer.queue_free()
		face_renderer = null
		face_background = null
		face_symbol = null
		face_callsign = null
```
