# RadioSubtitles::show_partial Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 69–76)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func show_partial(text: String) -> void
```

## Description

Show subtitle with current partial text

## Source

```gdscript
func show_partial(text: String) -> void:
	_current_text = text
	_is_transmitting = true
	visible = true
	_hide_timer.stop()
	_update_display()
```
