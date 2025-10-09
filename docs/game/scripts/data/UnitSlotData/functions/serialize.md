# UnitSlotData::serialize Function Reference

*Defined at:* `scripts/data/UnitSlotData.gd` (lines 17–26)</br>
*Belongs to:* [UnitSlotData](../../UnitSlotData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize data to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"key": key,
		"title": title,
		"callsign": callsign,
		"allowed_roles": allowed_roles.duplicate(),
		"start_position": ContentDB.v2(start_position)
	}
```
