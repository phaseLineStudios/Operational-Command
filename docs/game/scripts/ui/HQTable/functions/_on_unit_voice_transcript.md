# HQTable::_on_unit_voice_transcript Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 153–157)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_unit_voice_transcript(callsign: String, message: String) -> void
```

## Description

Handle unit voice responses for transcript (both acknowledgments and auto-responses)

## Source

```gdscript
func _on_unit_voice_transcript(callsign: String, message: String) -> void:
	if document_controller and message != "":
		await document_controller.add_transcript_entry(callsign, message)
```
