# DocumentController::prev_page_transcript Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 803–807)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func prev_page_transcript() -> void
```

## Source

```gdscript
func prev_page_transcript() -> void:
	if _transcript_face:
		_transcript_face.prev_page()
```
