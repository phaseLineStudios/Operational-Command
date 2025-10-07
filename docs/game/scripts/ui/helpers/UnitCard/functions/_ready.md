# UnitCard::_ready Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 31–39)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	var sb := get_theme_stylebox("panel")
	if sb:
		_base_style = sb.duplicate()
```
