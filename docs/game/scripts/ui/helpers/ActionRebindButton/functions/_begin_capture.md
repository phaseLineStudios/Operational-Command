# ActionRebindButton::_begin_capture Function Reference

*Defined at:* `scripts/ui/helpers/ActionRebindButton.gd` (lines 33–39)</br>
*Belongs to:* [ActionRebindButton](../../ActionRebindButton.md)

**Signature**

```gdscript
func _begin_capture() -> void
```

## Description

Enter capture mode.

## Source

```gdscript
func _begin_capture() -> void:
	_capturing = true
	text = "Press a key… (ESC to clear)"
	focus_mode = FOCUS_ALL
	grab_focus()
```
