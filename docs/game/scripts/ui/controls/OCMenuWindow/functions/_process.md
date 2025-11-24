# OCMenuWindow::_process Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 42–46)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
	if Engine.is_editor_hint():
		%Title.text = window_title
```
