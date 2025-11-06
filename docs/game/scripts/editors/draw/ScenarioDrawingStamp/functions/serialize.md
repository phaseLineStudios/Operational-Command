# ScenarioDrawingStamp::serialize Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawingStamp.gd` (lines 23–42)</br>
*Belongs to:* [ScenarioDrawingStamp](../../ScenarioDrawingStamp.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

- **Return Value**: Dictionary.

## Description

Serialize stamp.

## Source

```gdscript
func serialize() -> Dictionary:
	var out := serialize_base()
	(
		out
		. merge(
			{
				"type": "stamp",
				"texture_path": texture_path,
				"modulate": modulate.to_html(true),
				"opacity": opacity,
				"position_m": ContentDB.v2(position_m),
				"scale": scale,
				"rotation_deg": rotation_deg,
				"label": label,
			}
		)
	)
	return out
```
