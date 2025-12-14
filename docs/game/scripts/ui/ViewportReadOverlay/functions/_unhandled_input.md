# ViewportReadOverlay::_unhandled_input Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 54–60)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		close()
		if consume_escape:
			get_viewport().set_input_as_handled()
```
