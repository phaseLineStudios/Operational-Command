# ScenarioEditorOverlay::on_mouse_move Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 167–172)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func on_mouse_move(pos: Vector2) -> void
```

## Description

Update hover state and schedule redraw

## Source

```gdscript
func on_mouse_move(pos: Vector2) -> void:
	_hover_pos = pos
	_hover_pick = _pick_at(pos)
	queue_redraw()
```
