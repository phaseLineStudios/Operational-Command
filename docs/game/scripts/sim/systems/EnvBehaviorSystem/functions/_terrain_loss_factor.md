# EnvBehaviorSystem::_terrain_loss_factor Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 264–279)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _terrain_loss_factor(unit: ScenarioUnit) -> float
```

## Source

```gdscript
func _terrain_loss_factor(unit: ScenarioUnit) -> float:
	if movement_adapter == null or movement_adapter.renderer == null:
		return 1.0
	var pg: PathGrid = movement_adapter.renderer.path_grid
	if pg == null:
		return 1.0
	var c := pg.world_to_cell(unit.position_m)
	if not pg._in_bounds(c):
		return 1.0
	if pg._astar and pg._astar.is_in_boundsv(c):
		var w: float = max(pg._astar.get_point_weight_scale(c), 0.001)
		# Dense/rough terrain increases loss risk slightly; roads reduce it.
		return clamp(0.8 + (w - 1.0) * 0.2, 0.5, 1.5)
	return 1.0
```
