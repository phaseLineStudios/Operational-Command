# ScenarioToolBase::handle_input Function Reference

*Defined at:* `scripts/editors/tools/ScenarioToolBase.gd` (lines 35–45)</br>
*Belongs to:* [ScenarioToolBase](../ScenarioToolBase.md)

**Signature**

```gdscript
func handle_input(event: InputEvent) -> bool
```

## Description

Editor forwards overlay input here

## Source

```gdscript
func handle_input(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		return _on_mouse_move(event)
	elif event is InputEventMouseButton:
		return _on_mouse_button(event)
	elif event is InputEventKey:
		return _on_key(event)

	return false
```
