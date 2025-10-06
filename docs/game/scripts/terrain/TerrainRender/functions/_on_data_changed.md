# TerrainRender::_on_data_changed Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 180–185)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func _on_data_changed() -> void
```

## Description

Reconfigure if terrain data is changed

## Source

```gdscript
func _on_data_changed() -> void:
	_debounce_relayout_and_push()
	if path_grid and nav_auto_build:
		path_grid.rebuild(nav_default_profile)
```
