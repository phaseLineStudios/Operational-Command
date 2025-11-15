# DocumentFace::set_page Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 56–66)</br>
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
		current_page = page
		update_page_indicator()
		page_changed.emit(current_page)
	else:
		LogService.warning(
			"Invalid page %d (total: %d), ignoring" % [page, total_pages], "DocumentFace.gd"
		)
```
