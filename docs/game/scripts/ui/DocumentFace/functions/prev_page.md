# DocumentFace::prev_page Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 81–83)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func prev_page() -> void
```

## Description

Navigate to previous page

## Source

```gdscript
func prev_page() -> void:
	if current_page > 0:
		set_page(current_page - 1)
```
