# PathGrid::_raster_key Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 473–487)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _raster_key(kind: String) -> String
```

## Description

Keys for intermediate rasters (don’t include profile so they can be reused)

## Source

```gdscript
func _raster_key(kind: String) -> String:
	return (
		"%s|%s|v=%d/%d/%d/%d|cell=%.1f"
		% [
			str(data.get_instance_id()),
			kind,
			_terrain_epoch,
			_elev_epoch,
			_surfaces_epoch,
			_lines_epoch,
			cell_size_m
		]
	)
```
