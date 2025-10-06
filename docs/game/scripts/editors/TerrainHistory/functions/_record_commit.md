# TerrainHistory::_record_commit Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 39–44)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _record_commit(desc: String) -> void
```

## Description

Record a commit to history

## Source

```gdscript
func _record_commit(desc: String) -> void:
	_past.append(desc)
	_future.clear()
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())
```
