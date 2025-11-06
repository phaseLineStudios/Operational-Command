# ScenarioDrawing::deserialize_base Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawing.gd` (lines 28–34)</br>
*Belongs to:* [ScenarioDrawing](../../ScenarioDrawing.md)

**Signature**

```gdscript
func deserialize_base(d: Dictionary) -> void
```

- **d**: Source dictionary.

## Description

Apply common fields from Dictionary.

## Source

```gdscript
func deserialize_base(d: Dictionary) -> void:
	id = d.get("id", id)
	visible = d.get("visible", visible)
	layer = int(d.layer)
	order = int(d.order)
```
