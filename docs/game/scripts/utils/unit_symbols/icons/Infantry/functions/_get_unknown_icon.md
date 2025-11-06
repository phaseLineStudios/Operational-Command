# Infantry::_get_unknown_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Infantry.gd` (lines 30–34)</br>
*Belongs to:* [Infantry](../../Infantry.md)

**Signature**

```gdscript
func _get_unknown_icon() -> Dictionary
```

## Source

```gdscript
func _get_unknown_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(45, 45), Vector2(155, 155)], [Vector2(45, 155), Vector2(155, 45)]]
	}
```
