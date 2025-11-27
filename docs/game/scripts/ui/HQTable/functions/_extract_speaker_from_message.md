# HQTable::_extract_speaker_from_message Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 140–162)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _extract_speaker_from_message(text: String) -> String
```

## Description

Extract speaker callsign from message text if present, otherwise return "HQ".
Handles formats: "ALPHA: message", "ALPHA message", or plain messages.

## Source

```gdscript
func _extract_speaker_from_message(text: String) -> String:
	# Check for "CALLSIGN: message" format
	var colon_pos := text.find(":")
	if colon_pos > 0:
		var potential_callsign := text.substr(0, colon_pos).strip_edges()
		# Verify it looks like a callsign (uppercase letters, possibly with numbers)
		if potential_callsign.length() >= 2 and potential_callsign.length() <= 12:
			if potential_callsign.to_upper() == potential_callsign:
				return potential_callsign

	# Check for "CALLSIGN message" format (first word is all caps)
	var words := text.split(" ", false, 1)
	if words.size() >= 2:
		var first_word := words[0].strip_edges()
		# Check if first word is uppercase and looks like a callsign
		if first_word.length() >= 2 and first_word.length() <= 12:
			if first_word.to_upper() == first_word and first_word.is_valid_identifier():
				return first_word

	# Default to HQ if no callsign detected
	return "HQ"
```
