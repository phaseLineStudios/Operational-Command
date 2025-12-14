# MilSymbol::_cache_put Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 113–124)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _cache_put(key: String, tex: ImageTexture) -> void
```

## Source

```gdscript
static func _cache_put(key: String, tex: ImageTexture) -> void:
	if key == "" or tex == null:
		return
	if _texture_cache.has(key):
		return
	_texture_cache[key] = tex
	_texture_cache_order.append(key)
	if _texture_cache_order.size() > _CACHE_MAX_ENTRIES:
		var old_key: String = _texture_cache_order.pop_front()
		_texture_cache.erase(old_key)
```
