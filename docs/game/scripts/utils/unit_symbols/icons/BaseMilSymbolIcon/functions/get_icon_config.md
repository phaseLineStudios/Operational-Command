# BaseMilSymbolIcon::get_icon_config Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/BaseIcon.gd` (lines 14–27)</br>
*Belongs to:* [BaseMilSymbolIcon](../../BaseMilSymbolIcon.md)

**Signature**

```gdscript
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary
```

- **Return Value**: Dictionary of icon config.

## Description

Retrieve Icon config.

## Source

```gdscript
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			return _get_friendly_icon()
		MilSymbol.UnitAffiliation.ENEMY:
			return _get_enemy_icon()
		MilSymbol.UnitAffiliation.NEUTRAL:
			return _get_neutral_icon()
		MilSymbol.UnitAffiliation.UNKNOWN:
			return _get_unknown_icon()
		_:
			return _get_default_icon()
```
