# LineLayer::_refresh_recipe_and_geometry Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 200–203)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _refresh_recipe_and_geometry(id: int) -> void
```

## Description

Recompute recipe (colors/mode/widths) and geometry (since snapping may change)

## Source

```gdscript
func _refresh_recipe_and_geometry(id: int) -> void:
	_upsert_from_data(id, true)
```
