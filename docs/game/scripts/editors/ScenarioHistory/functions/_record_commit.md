# ScenarioHistory::_record_commit Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 36–41)</br>
*Belongs to:* [ScenarioHistory](../ScenarioHistory.md)

**Signature**

```gdscript
func _record_commit(desc: String) -> void
```

## Source

```gdscript
func _record_commit(desc: String) -> void:
	_past.append(desc)
	_future.clear()
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())
```
