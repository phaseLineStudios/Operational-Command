# TerrainHistory::undo Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 19–27)</br>
*Belongs to:* [TerrainHistory](../../TerrainHistory.md)

**Signature**

```gdscript
func undo() -> void
```

## Description

undo the last action

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
