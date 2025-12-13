# RadioSubtitles::_is_ammo_type Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 400–404)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _is_ammo_type(token: String) -> bool
```

## Description

Check if a token is an ammo type

## Source

```gdscript
func _is_ammo_type(token: String) -> bool:
	var ammo_types_config = _suggestions_config.get("ammo_types", {})
	return ammo_types_config.has(token)
```
