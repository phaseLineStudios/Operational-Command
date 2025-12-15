# TriggerVM::run Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 59–77)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func run(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void
```

- **expr_src**: Expression source.
- **ctx**: becomes constants accessible in the expression.
- **debug_info**: Optional debug info for error messages (trigger_id, expr_type).

## Description

Run side-effect expressions (activation/deactivation). Ignores return values.
Handles blocking sleep and dialog blocking:
- If sleep is called, remaining statements are scheduled for later execution
- If dialog blocking is requested, remaining statements execute when dialog closes

## Source

```gdscript
func run(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void:
	LogService.trace("Ran trigger expression", "TriggerVM.gd:49")
	var src := expr_src.strip_edges()
	if src == "":
		return

	# Reset sleep state before execution
	if _api:
		_api._reset_sleep()
		# Store context in API so trigger functions can access it
		_api._current_context = ctx

	# Strip comments before executing
	var clean_src := _strip_comments(src)

	# Execute with control flow support
	_execute_script(clean_src, ctx, debug_info)
```
