# Infantry::_get_friendly_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Infantry.gd` (lines 9–15)</br>
*Belongs to:* [Infantry](../../Infantry.md)

**Signature**

```gdscript
func _get_friendly_icon() -> Dictionary
```

## Source

```gdscript
func _get_friendly_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths": [[Vector2(25, 50), Vector2(175, 150)], [Vector2(25, 150), Vector2(175, 50)]]
	}
```
