# DocumentFace::update_page_indicator Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 38–55)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func update_page_indicator() -> void
```

## Description

Set the page indicator text and button visibility

## Source

```gdscript
func update_page_indicator() -> void:
	if page_indicator:
		if total_pages > 1:
			page_indicator.text = "Page %d/%d" % [current_page + 1, total_pages]
			page_indicator.visible = true
		else:
			page_indicator.visible = false

	# Update button states
	if prev_button:
		prev_button.visible = total_pages > 1
		prev_button.disabled = current_page <= 0

	if next_button:
		next_button.visible = total_pages > 1
		next_button.disabled = current_page >= total_pages - 1
```
