# CustomCommand::serialize Function Reference

*Defined at:* `scripts/data/CustomCommand.gd` (lines 38–46)</br>
*Belongs to:* [CustomCommand](../../CustomCommand.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize to dictionary for JSON persistence.

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"keyword": keyword,
		"additional_grammar": additional_grammar.duplicate(),
		"trigger_id": trigger_id,
		"route_as_order": route_as_order
	}
```
