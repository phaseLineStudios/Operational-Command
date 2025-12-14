# DocumentController::_split_into_pages Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 651–733)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _split_into_pages(content: RichTextLabel, full_text: String) -> Array[String]
```

## Description

Split content into pages based on what fits in the RichTextLabel

## Source

```gdscript
func _split_into_pages(content: RichTextLabel, full_text: String) -> Array[String]:
	var pages: Array[String] = []

	if full_text.is_empty():
		pages.append("")
		return pages

	# Set the full text to measure once
	content.text = full_text
	await get_tree().process_frame  # Wait for layout

	var total_lines := content.get_line_count()
	var visible_lines := content.get_visible_line_count()

	# Safety check - if visible_lines is 0 or unreasonably small, use default
	if visible_lines < 10:
		LogService.warning(
			"visible_lines=%d is too small, defaulting to 30" % visible_lines,
			"DocumentController.gd"
		)
		visible_lines = 30

	# If everything fits on one page
	if total_lines <= visible_lines:
		pages.append(full_text)
		return pages

	# Split by lines and use greedy line-by-line approach
	var all_lines := full_text.split("\n")
	var line_idx := 0

	while line_idx < all_lines.size():
		# Build current page by adding lines until we overflow
		var page_lines: Array[String] = []

		# Keep adding lines while they fit
		while line_idx < all_lines.size():
			# Try adding the next line
			page_lines.append(all_lines[line_idx])
			var test_text := "\n".join(page_lines)

			content.text = test_text
			await get_tree().process_frame

			var test_total := content.get_line_count()

			# Use cached visible_lines for consistency
			if test_total <= visible_lines:
				# This line fits! Keep it and try adding more
				line_idx += 1
			else:
				# This line doesn't fit, remove it and finish this page
				page_lines.pop_back()
				break

		# If we didn't add any lines (very long line that doesn't fit), force add at least one
		if page_lines.is_empty() and line_idx < all_lines.size():
			page_lines.append(all_lines[line_idx])
			line_idx += 1
			LogService.warning(
				"Line too long to fit on page, forcing it anyway", "DocumentController.gd"
			)

		# Add the completed page (skip empty pages unless it's the first)
		var page_text := "\n".join(page_lines)
		# Only add if page has content, or if no pages exist yet
		if page_text.strip_edges() != "":
			pages.append(page_text)
		elif pages.is_empty():
			# Ensure at least one page exists (even if empty)
			LogService.warning("Creating empty first page", "DocumentController.gd")
			pages.append(page_text)

	# Ensure at least one page
	if pages.is_empty():
		LogService.warning(
			"No pages created, adding full text as single page", "DocumentController.gd"
		)
		pages.append(full_text)

	return pages
```
