# EnvBehaviorSystem::_terrain_bog_factor Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 245–260)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _terrain_bog_factor(unit: ScenarioUnit) -> float
```

## Description

Terrain multiplier for bog risk based on path grid weight.

## Source

```gdscript
func _terrain_bog_factor(unit: ScenarioUnit) -> float:
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
		# Heavier weights (mud/soft ground) increase bog risk; roads (w<1) reduce it.
		return clamp(w, 0.5, 2.0)
	return 1.0
```
