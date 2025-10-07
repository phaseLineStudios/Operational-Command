# PathGrid::astar_setup_defaults Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 91–101)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func astar_setup_defaults() -> void
```

## Source

```gdscript
func astar_setup_defaults() -> void:
	_astar.diagonal_mode = (
		AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
		if allow_diagonals
		else AStarGrid2D.DIAGONAL_MODE_NEVER
	)
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.jumping_enabled = false
```
