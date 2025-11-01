class_name TriggerVM
extends RefCounted
## Tiny sandbox runner around Godot's Expression.
## Parses and runs simple expressions with a whitelisted helper API.

var _api: TriggerAPI
var _cache: Dictionary = {}


## Provide the helper API used by scripts.
func set_api(api: TriggerAPI) -> void:
	_api = api


## Evaluate a condition expression.
## [param expr_src] Expression source.
## [param ctx] becomes constants accessible in the expression.
## [return] empty/"true" -> true.
func eval_condition(expr_src: String, ctx: Dictionary) -> bool:
	var src := expr_src.strip_edges()
	if src == "" or src == "true":
		return true

	var lines := _split_lines(src)
	var last: Variant = true
	for line in lines:
		var compiled := _compile(line, ctx)
		if compiled == null:
			return false

		var inputs := _values_for(compiled.names, ctx)
		last = compiled.expr.execute(inputs, _api, false, false)
		if compiled.expr.has_execute_failed():
			return false

		if typeof(last) == TYPE_BOOL and last == false:
			return false

		if typeof(last) == TYPE_NIL:
			return false

	return bool(last)


## Run side-effect expressions (activation/deactivation). Ignores return values.
## Handles blocking sleep and dialog blocking:
## - If sleep is called, remaining statements are scheduled for later execution
## - If dialog blocking is requested, remaining statements execute when dialog closes
## [param expr_src] Expression source.
## [param ctx] becomes constants accessible in the expression.
func run(expr_src: String, ctx: Dictionary) -> void:
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
		var compiled := _compile(line, ctx)
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


## Compile a given expression.
## [param src] Source to compile.
## [return] Compiled expression.
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


## Creates inputs from context.
## [param names] Compiled names.
## [param ctx] becomes constants accessible in the expression.
## [return] Array of inputs.
func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array:
	var vals: Array = []
	for n in names:
		vals.append(ctx.get(n))
	return vals


## Sorts context keys.
## [param ctx] becomes constants accessible in the expression.
## [return] Array of sorted keys.
func _sorted_keys(ctx: Dictionary) -> PackedStringArray:
	var ks := PackedStringArray()
	for k in ctx.keys():
		ks.append(String(k))
	ks.sort()
	return ks


## Split source by lines, respecting multi-line expressions.
## Handles parentheses, brackets, and braces to keep multi-line calls together.
## [param src] Source string.
## [return] PackedStringArray of code lines.
func _split_lines(src: String) -> PackedStringArray:
	var work := src.replace("\r", "\n")
	var out := PackedStringArray()
	var current := ""
	var paren_depth := 0
	var bracket_depth := 0
	var brace_depth := 0
	var in_string := false
	var string_char := ""
	var i := 0

	while i < work.length():
		var c := work[i]

		# Handle string literals
		if c == '"' or c == "'":
			if not in_string:
				in_string = true
				string_char = c
			elif c == string_char:
				# Check if escaped
				if i > 0 and work[i - 1] != "\\":
					in_string = false
			current += c
			i += 1
			continue

		# Skip if inside string
		if in_string:
			current += c
			i += 1
			continue

		# Track depth
		if c == "(":
			paren_depth += 1
		elif c == ")":
			paren_depth -= 1
		elif c == "[":
			bracket_depth += 1
		elif c == "]":
			bracket_depth -= 1
		elif c == "{":
			brace_depth += 1
		elif c == "}":
			brace_depth -= 1

		# Statement separator
		if c == ";" and paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
			var stmt := current.strip_edges()
			if stmt != "":
				out.append(stmt)
			current = ""
			i += 1
			continue

		# Newline - only split if all depths are zero
		if c == "\n":
			if paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
				var stmt := current.strip_edges()
				if stmt != "":
					out.append(stmt)
				current = ""
			else:
				# Keep the newline as a space for multi-line expressions
				current += " "
			i += 1
			continue

		current += c
		i += 1

	# Add remaining
	var stmt := current.strip_edges()
	if stmt != "":
		out.append(stmt)

	return out
