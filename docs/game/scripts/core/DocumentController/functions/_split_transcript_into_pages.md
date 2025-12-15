# DocumentController::_split_transcript_into_pages Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 554–645)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _split_transcript_into_pages(content: RichTextLabel, full_text: String) -> Array[String]
```

## Description

Split transcript into pages, keeping message blocks atomic
Each message block (timestamp + speaker + message + blank line) stays together

## Source

```gdscript
func _split_transcript_into_pages(content: RichTextLabel, full_text: String) -> Array[String]:
	var pages: Array[String] = []

	if full_text.is_empty():
		pages.append("")
		return pages

	# Set the full text to measure once
	content.text = full_text
	await get_tree().process_frame  # Wait for layout

	var total_lines := content.get_line_count()
	var visible_lines := content.get_visible_line_count()

	if visible_lines < 10:
		visible_lines = 30

	if total_lines <= visible_lines:
		pages.append(full_text)
		return pages

	var all_lines := full_text.split("\n")
	var blocks: Array[Array] = []

	# Header block: title, subtitle, blank line
	if all_lines.size() >= 3:
		blocks.append([all_lines[0], all_lines[1], all_lines[2]])
		var line_idx := 3

		# Message blocks: timestamp, message, blank line
		while line_idx < all_lines.size():
			var block: Array[String] = []
			for i in range(3):
				if line_idx < all_lines.size():
					block.append(all_lines[line_idx])
					line_idx += 1
				else:
					break

			if block.size() > 0:
				blocks.append(block)
	else:
		blocks.append(all_lines)

	# Build pages by adding blocks atomically
	var block_idx := 0
	while block_idx < blocks.size():
		var page_blocks: Array[Array] = []

		while block_idx < blocks.size():
			page_blocks.append(blocks[block_idx])

			var test_lines: Array[String] = []
			for block in page_blocks:
				test_lines.append_array(block)
			var test_text := "\n".join(test_lines)

			content.text = test_text
			await get_tree().process_frame

			var test_total := content.get_line_count()

			if test_total <= visible_lines:
				block_idx += 1
			else:
				page_blocks.pop_back()
				break

		if page_blocks.is_empty() and block_idx < blocks.size():
			page_blocks.append(blocks[block_idx])
			block_idx += 1
			LogService.warning(
				"Message block too long to fit on page, forcing it anyway", "DocumentController.gd"
			)

		var page_lines: Array[String] = []
		for block in page_blocks:
			page_lines.append_array(block)
		var page_text := "\n".join(page_lines)

		if page_text.strip_edges() != "":
			pages.append(page_text)

	if pages.is_empty():
		LogService.warning(
			"No transcript pages created, adding full text as single page", "DocumentController.gd"
		)
		pages.append(full_text)

	return pages
```
