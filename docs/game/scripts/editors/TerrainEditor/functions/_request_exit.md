# TerrainEditor::_request_exit Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 145–152)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _request_exit(kind: String) -> void
```

## Description

Request to exit the editor

## Source

```gdscript
func _request_exit(kind: String) -> void:
	_pending_exit_kind = kind
	if _dirty:
		_exit_dialog.popup_centered()
	else:
		_perform_pending_exit()
```
