# DocumentFace::next_page Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 91–95)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func next_page() -> void
```

## Description

Navigate to next page

## Source

```gdscript
func next_page() -> void:
	if current_page < total_pages - 1:
		set_page(current_page + 1)
```
