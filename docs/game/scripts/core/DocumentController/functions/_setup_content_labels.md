# DocumentController::_setup_content_labels Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 199–221)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _setup_content_labels() -> void
```

## Description

Setup document face scenes and get RichTextLabel content containers

## Source

```gdscript
func _setup_content_labels() -> void:
	# Intel document face
	_intel_face = DOCUMENT_FACE_SCENE.instantiate()
	_intel_face.page_change_sounds = page_change_sounds
	_intel_viewport.add_child(_intel_face)
	_intel_content = _intel_face.get_node("%PaperContent")
	_intel_face.page_changed.connect(_on_intel_page_changed)

	# Transcript document face
	_transcript_face = DOCUMENT_FACE_SCENE.instantiate()
	_transcript_face.page_change_sounds = page_change_sounds
	_transcript_viewport.add_child(_transcript_face)
	_transcript_content = _transcript_face.get_node("%PaperContent")
	_transcript_face.page_changed.connect(_on_transcript_page_changed)

	# Briefing document face
	_briefing_face = DOCUMENT_FACE_SCENE.instantiate()
	_briefing_face.page_change_sounds = page_change_sounds
	_briefing_viewport.add_child(_briefing_face)
	_briefing_content = _briefing_face.get_node("%PaperContent")
	_briefing_face.page_changed.connect(_on_briefing_page_changed)
```
