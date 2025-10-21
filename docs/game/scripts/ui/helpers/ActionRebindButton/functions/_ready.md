# ActionRebindButton::_ready Function Reference

*Defined at:* `scripts/ui/helpers/ActionRebindButton.gd` (lines 27–31)</br>
*Belongs to:* [ActionRebindButton](../../ActionRebindButton.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	pressed.connect(_begin_capture)
	refresh_label()
```
