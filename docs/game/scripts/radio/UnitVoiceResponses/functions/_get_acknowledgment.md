# UnitVoiceResponses::_get_acknowledgment Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 130–137)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _get_acknowledgment(order_type: String) -> String
```

- **order_type**: Order type string (MOVE, ATTACK, etc.).
- **Return Value**: Random acknowledgment phrase.

## Description

Get a random acknowledgment phrase for an order type.

## Source

```gdscript
func _get_acknowledgment(order_type: String) -> String:
	var phrases: Array = ACKNOWLEDGMENTS.get(order_type, [])
	if phrases.is_empty():
		phrases = ["Roger.", "Copy.", "Acknowledged."]

	return phrases[randi() % phrases.size()]
```
