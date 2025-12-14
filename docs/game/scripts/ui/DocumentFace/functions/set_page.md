# DocumentFace::set_page Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 67–82)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func set_page(page: int) -> void
```

## Description

Set the current page

## Source

```gdscript
func set_page(page: int) -> void:
	if page >= 0 and page < total_pages:
		var old_page := current_page
		current_page = page
		update_page_indicator()
		page_changed.emit(current_page)

		# Play page change sound (but not on initial page set)
		if old_page != current_page:
			_play_page_change_sound()
	else:
		LogService.warning(
			"Invalid page %d (total: %d), ignoring" % [page, total_pages], "DocumentFace.gd"
		)
```
