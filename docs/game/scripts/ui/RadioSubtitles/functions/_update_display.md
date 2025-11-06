# RadioSubtitles::_update_display Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 72–88)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _update_display() -> void
```

## Description

Update the display with current text and suggestions

## Source

```gdscript
func _update_display() -> void:
	if not _subtitle_label:
		return

	# Update subtitle text (convert number words to digits)
	var display_text := _convert_numbers_to_digits(_current_text)
	if _is_transmitting:
		display_text += " _"  # Show cursor while transmitting
	_subtitle_label.text = display_text

	# Update suggestions
	if _is_transmitting and _current_text != "":
		_update_suggestions()
	else:
		_clear_suggestions()
```
