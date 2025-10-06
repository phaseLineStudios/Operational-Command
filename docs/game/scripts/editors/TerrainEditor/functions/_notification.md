# TerrainEditor::_notification Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 85–91)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Catch resize and close notifications

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		_request_exit("app")
```
