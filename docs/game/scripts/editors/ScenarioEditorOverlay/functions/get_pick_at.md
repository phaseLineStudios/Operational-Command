# ScenarioEditorOverlay::get_pick_at Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 112–115)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func get_pick_at(pos: Vector2) -> Dictionary
```

## Description

Return the closest pickable entity under the given screen position

## Source

```gdscript
func get_pick_at(pos: Vector2) -> Dictionary:
	return _pick_at(pos)
```
