# UnitCard::setup Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 52–85)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func setup(u: UnitData) -> void
```

## Description

Initialize card visual with a unit dictionary.

## Source

```gdscript
func setup(u: UnitData) -> void:
	unit = u
	mouse_filter = Control.MOUSE_FILTER_STOP
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 64)

	# Children should not swallow input (so drag starts from the card)
	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_role.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Text
	_name.text = String(u.title)
	_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_role.text = String(u.role)
	_cost.text = "Cost: %d" % int(u.cost if u.cost else 0)
	tooltip_text = "%s (%s) • Cost: %d" % [_name.text, _role.text, int(u.cost if u.cost else 0)]

	# Icon
	var tex: Texture2D = null
	if u.icon:
		tex = u.icon
	if tex == null and default_icon:
		tex = default_icon
	if tex == null and fallback_default_icon:
		tex = fallback_default_icon
	_icon.texture = tex

	u.icons_ready.connect(func(): _icon.texture = u.icon)

	_update_style()
```
