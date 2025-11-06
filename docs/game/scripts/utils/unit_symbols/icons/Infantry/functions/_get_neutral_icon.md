# Infantry::_get_neutral_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Infantry.gd` (lines 23–29)</br>
*Belongs to:* [Infantry](../../Infantry.md)

**Signature**

```gdscript
func _get_neutral_icon() -> Dictionary
```

## Source

```gdscript
func _get_neutral_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(45, 45), Vector2(155, 155)], [Vector2(45, 155), Vector2(155, 45)]]
	}
```
