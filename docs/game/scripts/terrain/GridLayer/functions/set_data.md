# GridLayer::set_data Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 15–20)</br>
*Belongs to:* [GridLayer](../../GridLayer.md)

**Signature**

```gdscript
func set_data(d: TerrainData) -> void
```

## Source

```gdscript
func set_data(d: TerrainData) -> void:
	data = d
	_need_bake = true
	queue_redraw()
```
