# ScenarioDrawing::serialize_base Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawing.gd` (lines 17–25)</br>
*Belongs to:* [ScenarioDrawing](../../ScenarioDrawing.md)

**Signature**

```gdscript
func serialize_base() -> Dictionary
```

- **Return Value**: Dictionary with common fields.

## Description

Serialize to JSON-friendly Dictionary.

## Source

```gdscript
func serialize_base() -> Dictionary:
	return {
		"id": id,
		"visible": visible,
		"layer": layer,
		"order": order,
	}
```
