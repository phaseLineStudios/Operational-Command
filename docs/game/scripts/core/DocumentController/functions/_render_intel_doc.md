# DocumentController::_render_intel_doc Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 243–257)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _render_intel_doc() -> void
```

## Description

Render intel document content (placeholder)

## Source

```gdscript
func _render_intel_doc() -> void:
	_intel_full_content = "[center][b]INTELLIGENCE SUMMARY[/b][/center]\n\n"
	_intel_full_content += "[i]No intelligence items available.[/i]\n\n"
	_intel_full_content += "This document will contain mission-specific intelligence briefings, "
	_intel_full_content += "enemy force estimates, terrain analysis, and other relevant information."

	_intel_pages = await _split_into_pages(_intel_content, _intel_full_content)
	# Initialize face state
	_intel_face.total_pages = _intel_pages.size()
	_intel_face.current_page = 0
	_intel_face.update_page_indicator()
	# Display first page content
	_display_page(_intel_face, _intel_content, _intel_pages, 0)
```
