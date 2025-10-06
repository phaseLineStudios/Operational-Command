# ScenarioHistory::undo Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 17–25)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func undo() -> void
```

## Description

Undo last action

## Source

```gdscript
func undo() -> void:
	if _past.is_empty():
		return
	var last: String = _past.pop_back()
	_ur.undo()
	_future.append(last)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())
```
