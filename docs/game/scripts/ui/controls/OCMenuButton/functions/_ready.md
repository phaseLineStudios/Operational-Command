# OCMenuButton::_ready Function Reference

*Defined at:* `scripts/ui/controls/OcMenuButton.gd` (lines 59–63)</br>
*Belongs to:* [OCMenuButton](../../OCMenuButton.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	mouse_entered.connect(_play_hover)
	pressed.connect(_play_pressed)
```
