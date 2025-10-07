# TerrainRender::to_local Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 282–285)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func to_local(pos: Vector2) -> Vector2
```

## Source

```gdscript
func to_local(pos: Vector2) -> Vector2:
	return pos - global_position
```
