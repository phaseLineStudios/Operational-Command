# DocumentFace::set_total_pages Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 84–89)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func set_total_pages(count: int) -> void
```

## Description

Set total pages

## Source

```gdscript
func set_total_pages(count: int) -> void:
	total_pages = max(1, count)
	current_page = clampi(current_page, 0, total_pages - 1)
	update_page_indicator()
```
