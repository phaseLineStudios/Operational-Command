# AmmoDamageConfig::_resolve_profile Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 35–53)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func _resolve_profile(ammo_type: String, visited: Array) -> Dictionary
```

## Description

Resolve/normalize a profile, supporting aliases, dictionaries, and scalars.

## Source

```gdscript
func _resolve_profile(ammo_type: String, visited: Array) -> Dictionary:
	var key := String(ammo_type)
	if key == "" or visited.has(key):
		return _DEFAULT_PROFILE.duplicate(true)

	var entry: Variant = damage_by_type.get(key, null)
	if entry == null:
		return _DEFAULT_PROFILE.duplicate(true)

	match typeof(entry):
		TYPE_STRING:
			var alias := String(entry)
			var chain := visited.duplicate()
			chain.append(key)
			return _resolve_profile(alias, chain)
		_:
			return _normalize_entry(entry)
```
