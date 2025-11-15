# HQTable::_on_radio_transcript_player_early Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 113–117)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_transcript_player_early(text: String) -> void
```

## Description

Handle player radio result for transcript

## Source

```gdscript
func _on_radio_transcript_player_early(text: String) -> void:
	if document_controller and text != "":
		await document_controller.add_transcript_entry("PLAYER", text)
```
