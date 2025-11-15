# MapController::refresh Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 282–285)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func refresh() -> void
```

## Description

Force-refresh the texture and refit

## Source

```gdscript
func refresh() -> void:
	_apply_viewport_texture()
	_update_viewport_to_renderer()
	_update_mesh_fit()
```
