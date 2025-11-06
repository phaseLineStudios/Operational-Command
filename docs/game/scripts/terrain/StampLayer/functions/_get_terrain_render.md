# StampLayer::_get_terrain_render Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 94–100)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func _get_terrain_render() -> TerrainRender
```

## Description

Get parent TerrainRender node.

## Source

```gdscript
func _get_terrain_render() -> TerrainRender:
	var node := get_parent()
	while node:
		if node is TerrainRender:
			return node as TerrainRender
		node = node.get_parent()
	return null
```
