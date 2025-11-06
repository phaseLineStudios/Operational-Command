# BaseMilSymbolIcon::_get_enemy_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/BaseIcon.gd` (lines 36–39)</br>
*Belongs to:* [BaseMilSymbolIcon](../../BaseMilSymbolIcon.md)

**Signature**

```gdscript
func _get_enemy_icon() -> Dictionary
```

- **Return Value**: Dictionary of icon config.

## Description

Get enemy icon (overrideable).

## Source

```gdscript
func _get_enemy_icon() -> Dictionary:
	return _get_default_icon()
```
