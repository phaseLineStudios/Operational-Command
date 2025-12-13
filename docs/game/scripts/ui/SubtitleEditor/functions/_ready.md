# SubtitleEditor::_ready Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 35–41)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_setup_connections()
	_setup_dialogs()
	_new_track()
	_update_ui_state()
```
