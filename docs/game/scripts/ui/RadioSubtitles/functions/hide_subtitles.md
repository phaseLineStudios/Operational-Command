# RadioSubtitles::hide_subtitles Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 89–94)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func hide_subtitles() -> void
```

## Description

Hide the subtitle display

## Source

```gdscript
func hide_subtitles() -> void:
	visible = false
	_current_text = ""
	_is_transmitting = false
```
