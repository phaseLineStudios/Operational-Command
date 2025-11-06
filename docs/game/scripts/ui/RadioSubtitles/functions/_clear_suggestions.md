# RadioSubtitles::_clear_suggestions Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 115–122)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _clear_suggestions() -> void
```

## Description

Clear all suggestions

## Source

```gdscript
func _clear_suggestions() -> void:
	if not _suggestions_container:
		return

	for child in _suggestions_container.get_children():
		child.queue_free()
```
