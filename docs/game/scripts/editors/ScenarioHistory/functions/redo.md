# ScenarioHistory::redo Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 27–35)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func redo() -> void
```

## Description

Redo next action

## Source

```gdscript
func redo() -> void:
	if _future.is_empty():
		return
	var next: String = _future.pop_back()
	_ur.redo()
	_past.append(next)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())
```
