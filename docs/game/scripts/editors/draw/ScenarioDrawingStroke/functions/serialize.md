# ScenarioDrawingStroke::serialize Function Reference

*Defined at:* `scripts/editors/draw/ScenarioDrawingStroke.gd` (lines 17–36)</br>
*Belongs to:* [ScenarioDrawingStroke](../../ScenarioDrawingStroke.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

- **Return Value**: Dictionary.

## Description

Serialize stroke.

## Source

```gdscript
func serialize() -> Dictionary:
	var pts: Array = []
	for p in points_m:
		pts.append(ContentDB.v2(p))
	var out := serialize_base()
	(
		out
		. merge(
			{
				"type": "stroke",
				"color": color.to_html(true),
				"width_px": width_px,
				"opacity": opacity,
				"points": pts,
			}
		)
	)
	return out
```
