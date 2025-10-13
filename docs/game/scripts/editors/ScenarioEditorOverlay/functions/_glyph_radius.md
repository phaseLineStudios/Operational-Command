# ScenarioEditorOverlay::_glyph_radius Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 637–654)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _glyph_radius(kind: StringName, idx: int) -> float
```

## Description

Return approximate visual radius for a glyph kind/index

## Source

```gdscript
func _glyph_radius(kind: StringName, idx: int) -> float:
	match kind:
		&"task":
			return (
				float(task_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"task", idx) else 1.0)
			)
		&"unit":
			return (
				float(unit_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"unit", idx) else 1.0)
			)
		&"slot":
			return (
				float(slot_icon_px) * 0.5 * (hover_scale if _is_highlighted(&"slot", idx) else 1.0)
			)
		_:
			return 0.0
```
