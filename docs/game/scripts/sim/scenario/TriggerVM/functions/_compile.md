# TriggerVM::_compile Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 83–116)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func _compile(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> Variant
```

- **src**: Source to compile (should already have comments stripped).
- **ctx**: Context dictionary.
- **debug_info**: Optional debug info for error messages.
- **Return Value**: Compiled expression, or null on error.

## Description

Compile a given expression.

## Source

```gdscript
func _compile(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> Variant:
	var names := _sorted_keys(ctx)
	var key := src + "\n--names--\n" + "|".join(names)
	if _cache.has(key):
		return _cache[key]

	var e := Expression.new()
	var err := e.parse(src, names)
	if err != OK:
		# Build detailed error message with context
		var error_msg := "TriggerVM parse error: %s" % e.get_error_text()

		# Add trigger context if available
		if debug_info.has("trigger_id") and debug_info.get("trigger_id", "") != "":
			error_msg += "\n  Trigger ID: %s" % debug_info.get("trigger_id", "")
		if debug_info.has("trigger_title") and debug_info.get("trigger_title", "") != "":
			error_msg += "\n  Trigger Title: %s" % debug_info.get("trigger_title", "")
		if debug_info.has("expr_type"):
			error_msg += "\n  Expression Type: %s" % debug_info.get("expr_type", "")

		# Add expression snippet
		var snippet := src
		if snippet.length() > 80:
			snippet = snippet.substr(0, 77) + "..."
		error_msg += "\n  Expression: %s" % snippet

		push_warning(error_msg)
		return null

	var out := {"expr": e, "names": names}
	_cache[key] = out
	return out
```
