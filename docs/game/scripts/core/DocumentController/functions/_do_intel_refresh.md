# DocumentController::_do_intel_refresh Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 704–709)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _do_intel_refresh() -> void
```

## Description

Debounced refresh functions - called after timer expires

## Source

```gdscript
func _do_intel_refresh() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_intel_material, _intel_viewport)
```
