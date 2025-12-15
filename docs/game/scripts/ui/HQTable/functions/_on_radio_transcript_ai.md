# HQTable::_on_radio_transcript_ai Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 138–151)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_transcript_ai(level: String, text: String, unit: String = "") -> void
```

## Description

Handle AI radio messages for transcript

## Source

```gdscript
func _on_radio_transcript_ai(level: String, text: String, unit: String = "") -> void:
	if not document_controller or text == "":
		return

	if level == "debug":
		return

	await get_tree().process_frame

	# Use explicit unit parameter if provided, otherwise extract from message
	var speaker := unit if unit != "" else _extract_speaker_from_message(text)
	document_controller.add_transcript_entry(speaker, text)
```
