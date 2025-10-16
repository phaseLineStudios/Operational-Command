# TriggerVM::_compile Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 64–80)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _compile(src: String, ctx: Dictionary) -> Dictionary
```

- **src**: Source to compile.
- **Return Value**: Compiled expression.

## Description

Compile a given expression.

## Source

```gdscript
func _compile(src: String, ctx: Dictionary) -> Dictionary:
	var names := _sorted_keys(ctx)
	var key := src + "\n--names--\n" + "|".join(names)
	if _cache.has(key):
		return _cache[key]

	var e := Expression.new()
	var err := e.parse(src, names)
	if err != OK:
		push_warning("TriggerVM parse error: %s" % e.get_error_text())
		return {}

	var out := {"expr": e, "names": names}
	_cache[key] = out
	return out
```
