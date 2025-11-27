# ScenarioEditorOverlay::_is_highlighted Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 442–448)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _is_highlighted(t: StringName, idx: int) -> bool
```

## Description

Check if a glyph of type/index is hovered or selected

## Source

```gdscript
func _is_highlighted(t: StringName, idx: int) -> bool:
	return (
		(_hover_pick.get("type", &"") == t and _hover_pick.get("index", -1) == idx)
		or (_selected_pick.get("type", &"") == t and _selected_pick.get("index", -1) == idx)
	)
```
