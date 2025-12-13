# SimWorld::_get_contact_key Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 260–266)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _get_contact_key(id_a: String, id_b: String) -> String
```

## Description

Get or create cached contact key for a pair of unit IDs.

## Source

```gdscript
func _get_contact_key(id_a: String, id_b: String) -> String:
	var cache_key := "%s|%s" % [id_a, id_b]
	if not _contact_key_cache.has(cache_key):
		_contact_key_cache[cache_key] = cache_key
	return _contact_key_cache[cache_key]
```
