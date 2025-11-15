# TriggerVM::run Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 53–107)</br>
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

	var lines := _split_lines(src)
	for i in lines.size():
		var line := lines[i]
		var compiled: Variant = _compile(line, ctx, debug_info)
		if compiled == null or compiled.is_empty():
			continue
		var inputs := _values_for(compiled.names, ctx)
		compiled.expr.execute(inputs, _api, false, false)

		# Check if sleep was requested after this statement
		if _api and _api._is_sleep_requested():
			# Collect remaining statements
			var remaining_lines := PackedStringArray()
			for j in range(i + 1, lines.size()):
				remaining_lines.append(lines[j])

			if remaining_lines.size() > 0:
				var remaining_expr := "\n".join(remaining_lines)
				var sleep_duration := _api._get_sleep_duration()
				var use_realtime := _api._is_sleep_realtime()

				# Schedule remaining statements
				if _api.engine and _api.engine.has_method("schedule_action"):
					_api.engine.schedule_action(sleep_duration, remaining_expr, ctx, use_realtime)

			# Reset sleep state and stop processing
			_api._reset_sleep()
			return

		# Check if dialog blocking was requested after this statement
		if _api and _api._is_dialog_blocking():
			# Collect remaining statements
			var remaining_lines := PackedStringArray()
			for j in range(i + 1, lines.size()):
				remaining_lines.append(lines[j])

			if remaining_lines.size() > 0:
				var remaining_expr := "\n".join(remaining_lines)
				# Store the pending expression to execute when dialog closes
				_api._set_dialog_pending(remaining_expr, ctx)

			# Stop processing (dialog blocking flag remains set)
			return
```
