# CombatTest::_process Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 61–70)</br>
*Belongs to:* [CombatTest](../CombatTest.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

## Source

```gdscript
func _process(dt: float) -> void:
	if renderer and renderer.path_grid:
		if _su_a:
			_su_a.tick(dt, renderer.path_grid)
		if _su_b:
			_su_b.tick(dt, renderer.path_grid)
	if input_overlay:
		input_overlay.queue_redraw()
```
