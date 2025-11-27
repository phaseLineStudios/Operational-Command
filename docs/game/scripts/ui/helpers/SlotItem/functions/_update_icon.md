# SlotItem::_update_icon Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 111–125)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _update_icon() -> void
```

## Description

Set icon to assigned unit's icon or fall back to exported default.

## Source

```gdscript
func _update_icon() -> void:
	var tex: Texture2D = null
	if _assigned_unit:
		if _assigned_unit.icon:
			tex = _assigned_unit.icon
	if tex == null:
		tex = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.FRIEND,
			MilSymbol.UnitType.NONE,
			MilSymbolConfig.Size.MEDIUM,
			MilSymbol.UnitSize.NONE
		)
	_icon.texture = tex
```
