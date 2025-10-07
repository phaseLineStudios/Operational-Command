# MarginLayer::set_data Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 51–55)</br>
*Belongs to:* [MarginLayer](../../MarginLayer.md)

**Signature**

```gdscript
func set_data(d: TerrainData) -> void
```

## Description

API to set terrain data

## Source

```gdscript
func set_data(d: TerrainData) -> void:
	data = d
	queue_redraw()
```
