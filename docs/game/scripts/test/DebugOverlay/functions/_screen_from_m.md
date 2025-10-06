# DebugOverlay::_screen_from_m Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 234–236)</br>
*Belongs to:* [DebugOverlay](../DebugOverlay.md)

**Signature**

```gdscript
func _screen_from_m(pos_m: Vector2) -> Vector2
```

## Source

```gdscript
func _screen_from_m(pos_m: Vector2) -> Vector2:
	var map_local := _renderer.terrain_to_map(pos_m)
	return _renderer.global_position + map_local
```
