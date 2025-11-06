# RadioSubtitles::show_result Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 44–53)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func show_result(text: String) -> void
```

## Description

Show final result text

## Source

```gdscript
func show_result(text: String) -> void:
	_current_text = text
	_is_transmitting = false
	visible = true
	_update_display()

	# Auto-hide after delay
	_hide_timer.start(result_display_time)
```
