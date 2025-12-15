# DocumentController::next_page_transcript Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 790–794)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func next_page_transcript() -> void
```

## Source

```gdscript
func next_page_transcript() -> void:
	if _transcript_face:
		_transcript_face.next_page()
```
