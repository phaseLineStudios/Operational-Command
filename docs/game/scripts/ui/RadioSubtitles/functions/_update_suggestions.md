# RadioSubtitles::_update_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 124–147)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _update_suggestions() -> void
```

## Description

Analyze current text and generate suggestions for next word

## Source

```gdscript
func _update_suggestions() -> void:
	if not _suggestions_container:
		return

	# Clear existing suggestions
	for child in _suggestions_container.get_children():
		child.queue_free()

	var tokens := _normalize_and_tokenize(_current_text)
	var suggestions := _generate_suggestions(tokens)

	# Create suggestion labels
	var count := 0
	for suggestion in suggestions:
		if count >= max_suggestions:
			break

		var label := Label.new()
		label.text = suggestion
		label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7, 0.8))
		_suggestions_container.add_child(label)
		count += 1
```
