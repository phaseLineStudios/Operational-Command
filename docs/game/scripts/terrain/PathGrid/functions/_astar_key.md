# PathGrid::_astar_key Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 450–471)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _astar_key(profile: int) -> String
```

## Description

Create a stable cache key for A* instances (includes everything that changes weights)

## Source

```gdscript
func _astar_key(profile: int) -> String:
	return (
		(
			"%s|v=%d/%d/%d/%d|cell=%.1f|diag=%s|smax=%.3f|slopeK=%.3f|lineR=%.1f|roadBias=%.3f"
			% [
				str(data.get_instance_id()),
				_terrain_epoch,
				_elev_epoch,
				_surfaces_epoch,
				_lines_epoch,
				cell_size_m,
				str(allow_diagonals),
				max_traversable_grade,
				slope_multiplier_per_grade,
				line_influence_radius_m,
				road_bias_weight
			]
		)
		+ "|p=%d" % profile
	)
```
