# ScenarioEditorDrawTools::next_drawing_id Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 219–231)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func next_drawing_id(kind: String) -> String
```

- **kind**: "stroke" | "stamp".
- **Return Value**: Unique drawing ID string.

## Description

Generate unique drawing id.

## Source

```gdscript
func next_drawing_id(kind: String) -> String:
	var base := "draw_%s_" % kind
	var n := 1
	if editor.ctx.data and editor.ctx.data.drawings:
		for d in editor.ctx.data.drawings:
			if d is Resource and d.has_method("get"):
				var did := String(d.id)
				if did.begins_with(base):
					var tail := did.trim_prefix(base)
					var num := int(tail)
					if num >= n:
						n = num + 1
	return "%s%03d" % [base, n]
```
