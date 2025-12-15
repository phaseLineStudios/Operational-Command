# ScenarioHistory::_emit_changed Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 313–321)</br>
*Belongs to:* [ScenarioHistory](../../ScenarioHistory.md)

**Signature**

```gdscript
func _emit_changed(data)
```

## Source

```gdscript
static func _emit_changed(data):
	if data == null:
		return
	if data.has_method("emit_changed"):
		data.emit_changed()
	elif data.has_signal("changed"):
		data.emit_signal("changed")
```
