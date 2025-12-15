# MapController::_is_dynamic_viewport Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 240–250)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _is_dynamic_viewport() -> bool
```

## Description

Returns true if the TerrainViewport should update every frame.

## Source

```gdscript
func _is_dynamic_viewport() -> bool:
	if viewport_update_always:
		return true
	if renderer == null:
		return false
	var dbg := renderer.get_node_or_null("DebugOverlay")
	if dbg != null and "debug_enabled" in dbg:
		return bool(dbg.debug_enabled)
	return false
```
