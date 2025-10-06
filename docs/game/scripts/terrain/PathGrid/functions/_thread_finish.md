# PathGrid::_thread_finish Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 366–411)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _thread_finish(result: Variant, err: String) -> void
```

## Description

Create A* on main thread, cache it, swap in, and emit signals.

## Source

```gdscript
func _thread_finish(result: Variant, err: String) -> void:
	_build_running = false
	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null

	if err != "":
		_emit_build_failed(err)
		return
	if result == null:
		_emit_build_failed("no result")
		return

	var cols := int(result.cols)
	var rows := int(result.rows)
	var g := AStarGrid2D.new()
	g.region = Rect2i(0, 0, cols, rows)
	g.cell_size = Vector2(cell_size_m, cell_size_m)
	g.diagonal_mode = (
		AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
		if allow_diagonals
		else AStarGrid2D.DIAGONAL_MODE_NEVER
	)
	g.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	g.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	g.jumping_enabled = false
	g.update()

	var weights: PackedFloat32Array = result.weights
	var solids: PackedByteArray = result.solids

	for cy in rows:
		for cx in cols:
			var id := Vector2i(cx, cy)
			var idx := cy * cols + cx
			g.set_point_solid(id, solids[idx] == 1)
			g.set_point_weight_scale(id, max(weights[idx], 0.001))

	var key := String(result.key)
	_astar_cache[key] = g
	_astar = g

	_emit_grid_rebuilt()
	_emit_build_ready(int(result.profile))
```
