# DocumentController::_on_intel_page_changed Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 688–692)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _on_intel_page_changed(page_index: int) -> void
```

## Description

Page change handlers - update content and debounce texture refresh

## Source

```gdscript
func _on_intel_page_changed(page_index: int) -> void:
	_display_page(_intel_face, _intel_content, _intel_pages, page_index)
	_intel_refresh_timer.start()
```
