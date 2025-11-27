# HQTable::_init_document_controller Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 98–111)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_document_controller(scenario: ScenarioData) -> void
```

## Description

Initialize the document controller and render documents

## Source

```gdscript
func _init_document_controller(scenario: ScenarioData) -> void:
	if document_controller:
		await document_controller.init(%IntelDoc, %TranscriptDoc, %BriefingDoc, scenario)

		if sim:
			sim.radio_message.connect(_on_radio_transcript_ai)

		if unit_voices:
			unit_voices.unit_response.connect(_on_unit_voice_transcript)

		if unit_auto_voices:
			unit_auto_voices.unit_auto_response.connect(_on_unit_voice_transcript)
```
