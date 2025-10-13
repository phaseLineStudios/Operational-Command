# TerrainHistory::redo Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 29–37)</br>
*Belongs to:* [TerrainHistory](../../TerrainHistory.md)

**Signature**

```gdscript
func redo() -> void
```

## Description

Redo the last action

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
