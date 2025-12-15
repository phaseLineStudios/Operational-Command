# ScenarioHistory::restore_state Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 328–339)</br>
*Belongs to:* [ScenarioHistory](../../ScenarioHistory.md)

**Signature**

```gdscript
func restore_state(state: Dictionary) -> void
```

## Description

Restore history state from serialized data

## Source

```gdscript
func restore_state(state: Dictionary) -> void:
	if state.has("past"):
		_past = state["past"].duplicate()
	else:
		_past.clear()

	if state.has("future"):
		_future = state["future"].duplicate()
	else:
		_future.clear()

	emit_signal("history_changed", _past.duplicate(), _future.duplicate())
```
