# UnitVoiceResponses::_get_order_type_name Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 148–166)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _get_order_type_name(type: Variant) -> String
```

- **type**: Order type (int or string).
- **Return Value**: Order type name string.

## Description

Convert order type to string name.

## Source

```gdscript
func _get_order_type_name(type: Variant) -> String:
	const TYPE_NAMES := {
		0: "MOVE",
		1: "HOLD",
		2: "ATTACK",
		3: "DEFEND",
		4: "RECON",
		5: "FIRE",
		6: "REPORT",
		7: "CANCEL",
		8: "CUSTOM",
		9: "UNKNOWN"
	}

	if typeof(type) == TYPE_INT:
		return TYPE_NAMES.get(type, "UNKNOWN")
	return str(type).to_upper()
```
