# PathGrid::_elev_m_at Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 723–727)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _elev_m_at(p_m: Vector2) -> float
```

## Source

```gdscript
func _elev_m_at(p_m: Vector2) -> float:
	var px := data.world_to_elev_px(p_m)
	return data.get_elev_px(px) + float(data.base_elevation_m)
```
