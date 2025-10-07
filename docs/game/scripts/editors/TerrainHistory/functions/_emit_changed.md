# TerrainHistory::_emit_changed Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 206–212)</br>
*Belongs to:* [TerrainHistory](../../TerrainHistory.md)

**Signature**

```gdscript
func _emit_changed(data)
```

## Description

Emit a generic change notification on TerrainData.

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
