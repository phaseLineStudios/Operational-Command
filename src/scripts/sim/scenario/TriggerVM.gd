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
## [param debug_info] Optional debug info for error messages (trigger_id, expr_type).
## [return] empty/"true" -> true.
func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool:
	var src := expr_src.strip_edges()
	if src == "" or src == "true":
		return true

	# Store context in API so trigger functions can access it
	if _api:
		_api._current_context = ctx

	# Strip comments before splitting into lines
	var clean_src := _strip_comments(src)
	var lines := _split_lines(clean_src)
	var last: Variant = true
	for line in lines:
		var compiled: Variant = _compile(line, ctx, debug_info)
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
## [param debug_info] Optional debug info for error messages (trigger_id, expr_type).
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


## Compile a given expression.
## [param src] Source to compile (should already have comments stripped).
## [param ctx] Context dictionary.
## [param debug_info] Optional debug info for error messages.
## [return] Compiled expression, or null on error.
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

	var stmt: String
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
			stmt = current.strip_edges()
			if stmt != "":
				out.append(stmt)
			current = ""
			i += 1
			continue

		# Newline - only split if all depths are zero AND not continuing an operator
		if c == "\n":
			if paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
				stmt = current.strip_edges()
				# Check if line ends with a continuation operator/token
				var should_continue := _line_needs_continuation(stmt)
				if stmt != "" and not should_continue:
					out.append(stmt)
					current = ""
				else:
					# Keep the newline as a space for multi-line expressions
					current += " "
			else:
				# Keep the newline as a space for multi-line expressions
				current += " "
			i += 1
			continue

		current += c
		i += 1

	# Add remaining
	stmt = current.strip_edges()
	if stmt != "":
		out.append(stmt)

	return out


## Check if a line ends with a token that requires continuation on the next line.
## [param line] Line to check.
## [return] True if the line needs continuation.
func _line_needs_continuation(line: String) -> bool:
	if line == "":
		return false

	# Binary operators that require a right-hand side
	var continuation_tokens := [
		"and",
		"or",
		"not",
		"+",
		"-",
		"*",
		"/",
		"%",
		"==",
		"!=",
		"<",
		">",
		"<=",
		">=",
		"in",
		"is",
		".",
		",",
		"=",
	]

	for token in continuation_tokens:
		if line.ends_with(token):
			return true
		# Also check for token followed by whitespace (already stripped)
		if line.ends_with(token + " "):
			return true

	return false


## Execute a script with control flow support (if/elif/else, var, assignments).
## [param src] Source code (comments already stripped).
## [param ctx] Context dictionary.
## [param debug_info] Optional debug info for error messages.
func _execute_script(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void:
	var lines := _parse_indented_lines(src)
	var local_vars := {}  # Track local variables
	_execute_block(lines, 0, ctx, local_vars, debug_info)


## Execute a block of lines starting from a given index.
## Returns the index after the block ends.
## [param lines] Array of {indent: int, code: String}.
## [param start_idx] Starting index.
## [param ctx] Context dictionary.
## [param local_vars] Local variables dictionary.
## [param debug_info] Optional debug info.
## [return] Index after the block ends.
func _execute_block(
	lines: Array, start_idx: int, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> int:
	if start_idx >= lines.size():
		return start_idx

	var base_indent: int = lines[start_idx].indent
	var i := start_idx

	while i < lines.size():
		var line_info: Dictionary = lines[i]
		var indent: int = line_info.indent
		var code: String = line_info.code

		# If we've dedented, we're done with this block
		if indent < base_indent:
			return i

		# Skip if not at our level (deeper indentation means nested block)
		if indent > base_indent:
			i += 1
			continue

		# Handle if/elif/else
		if code.begins_with("if ") or code.begins_with("elif ") or code.begins_with("else"):
			i = _execute_if_block(lines, i, ctx, local_vars, debug_info)
			continue

		# Handle var declaration
		if code.begins_with("var "):
			_execute_var_declaration(code, ctx, local_vars, debug_info)
			i += 1

			# Check for sleep/dialog blocking after statement
			if _check_sleep_or_block(lines, i, ctx, local_vars):
				return lines.size()  # Stop execution
			continue

		# Handle assignment (variable = expression)
		if "=" in code and not ("==" in code or "!=" in code or "<=" in code or ">=" in code):
			_execute_assignment(code, ctx, local_vars, debug_info)
			i += 1

			# Check for sleep/dialog blocking after statement
			if _check_sleep_or_block(lines, i, ctx, local_vars):
				return lines.size()  # Stop execution
			continue

		# Otherwise, execute as expression (function call, etc.)
		_execute_expression(code, ctx, local_vars, debug_info)
		i += 1

		# Check for sleep/dialog blocking after statement
		if _check_sleep_or_block(lines, i, ctx, local_vars):
			return lines.size()  # Stop execution

	return i


## Execute an if/elif/else block.
## Returns the index after the entire if block ends.
func _execute_if_block(
	lines: Array, start_idx: int, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> int:
	var i := start_idx
	var base_indent: int = lines[i].indent
	var executed := false

	while i < lines.size():
		var line_info: Dictionary = lines[i]
		var indent: int = line_info.indent
		var code: String = line_info.code

		# Check if this is if/elif/else at our level
		if indent != base_indent:
			return i

		# Handle if statement
		if code.begins_with("if "):
			var condition := code.trim_prefix("if ").trim_suffix(":")
			var result := _evaluate_condition(condition, ctx, local_vars, debug_info)
			if result:
				executed = true
				i = _execute_block(lines, i + 1, ctx, local_vars, debug_info)
				# Skip remaining elif/else
				i = _skip_remaining_branches(lines, i, base_indent)
				return i
			else:
				# Skip this branch
				i = _skip_branch(lines, i + 1, base_indent)

		# Handle elif statement
		elif code.begins_with("elif ") and not executed:
			var condition := code.trim_prefix("elif ").trim_suffix(":")
			var result := _evaluate_condition(condition, ctx, local_vars, debug_info)
			if result:
				executed = true
				i = _execute_block(lines, i + 1, ctx, local_vars, debug_info)
				# Skip remaining elif/else
				i = _skip_remaining_branches(lines, i, base_indent)
				return i
			else:
				# Skip this branch
				i = _skip_branch(lines, i + 1, base_indent)

		# Handle else statement
		elif code.begins_with("else") and not executed:
			i = _execute_block(lines, i + 1, ctx, local_vars, debug_info)
			return i

		else:
			# No more branches
			return i

	return i


## Skip a branch (the indented block after if/elif/else).
func _skip_branch(lines: Array, start_idx: int, base_indent: int) -> int:
	var i := start_idx
	while i < lines.size():
		var indent: int = lines[i].indent
		if indent <= base_indent:
			return i
		i += 1
	return i


## Skip remaining elif/else branches after one has been executed.
func _skip_remaining_branches(lines: Array, start_idx: int, base_indent: int) -> int:
	var i := start_idx
	while i < lines.size():
		var line_info: Dictionary = lines[i]
		var indent: int = line_info.indent
		var code: String = line_info.code

		if indent < base_indent:
			return i

		if indent == base_indent and (code.begins_with("elif ") or code.begins_with("else")):
			i = _skip_branch(lines, i + 1, base_indent)
		else:
			return i

	return i


## Evaluate a condition expression.
func _evaluate_condition(
	condition: String, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> bool:
	var merged_ctx := ctx.duplicate()
	merged_ctx.merge(local_vars)
	var compiled: Variant = _compile(condition, merged_ctx, debug_info)
	if compiled == null:
		return false
	var inputs := _values_for(compiled.names, merged_ctx)
	var result: Variant = compiled.expr.execute(inputs, _api, false, false)
	return bool(result) if result != null else false


## Execute a var declaration (var name = expression).
func _execute_var_declaration(
	code: String, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> void:
	# Remove "var " prefix and split on "="
	var rest := code.trim_prefix("var ").strip_edges()
	var parts := rest.split("=", false, 1)
	if parts.size() < 1:
		return

	var var_name := parts[0].strip_edges()
	var value: Variant = null

	if parts.size() == 2:
		var expr := parts[1].strip_edges().trim_suffix(";")
		value = _eval_expression(expr, ctx, local_vars, debug_info)

	local_vars[var_name] = value


## Execute an assignment (variable = expression).
func _execute_assignment(
	code: String, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> void:
	var parts := code.split("=", false, 1)
	if parts.size() < 2:
		return

	var var_name := parts[0].strip_edges()
	var expr := parts[1].strip_edges().trim_suffix(";")
	var value: Variant = _eval_expression(expr, ctx, local_vars, debug_info)

	# Update local variable
	local_vars[var_name] = value


## Execute a single expression (function call, etc.).
func _execute_expression(
	code: String, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> void:
	var expr := code.strip_edges().trim_suffix(";")
	_eval_expression(expr, ctx, local_vars, debug_info)


## Evaluate an expression and return the result.
func _eval_expression(
	expr: String, ctx: Dictionary, local_vars: Dictionary, debug_info: Dictionary
) -> Variant:
	if expr == "":
		return null

	var merged_ctx := ctx.duplicate()
	merged_ctx.merge(local_vars)

	var compiled: Variant = _compile(expr, merged_ctx, debug_info)
	if compiled == null:
		return null

	var inputs := _values_for(compiled.names, merged_ctx)
	return compiled.expr.execute(inputs, _api, false, false)


## Check if sleep or dialog blocking was requested, and handle remaining code.
## Returns true if execution should stop.
func _check_sleep_or_block(
	lines: Array, current_idx: int, ctx: Dictionary, local_vars: Dictionary
) -> bool:
	if not _api:
		return false

	# Merge local variables into context for continuation
	var merged_ctx := ctx.duplicate()
	merged_ctx.merge(local_vars)

	# Check if sleep was requested
	if _api._is_sleep_requested():
		# Collect remaining code
		var remaining := _reconstruct_remaining(lines, current_idx)
		if remaining != "":
			var sleep_duration := _api._get_sleep_duration()
			var use_realtime := _api._is_sleep_realtime()
			if _api.engine and _api.engine.has_method("schedule_action"):
				_api.engine.schedule_action(sleep_duration, remaining, merged_ctx, use_realtime)
		_api._reset_sleep()
		return true

	# Check if dialog blocking was requested
	if _api._is_dialog_blocking():
		# Collect remaining code
		var remaining := _reconstruct_remaining(lines, current_idx)
		if remaining != "":
			_api._set_dialog_pending(remaining, merged_ctx)
		return true

	return false


## Reconstruct remaining source code from line array.
func _reconstruct_remaining(lines: Array, start_idx: int) -> String:
	if start_idx >= lines.size():
		return ""

	var result := PackedStringArray()
	for i in range(start_idx, lines.size()):
		var line_info: Dictionary = lines[i]
		var indent_str := ""
		for j in line_info.indent:
			indent_str += "    "  # 4 spaces per indent level
		result.append(indent_str + line_info.code)

	return "\n".join(result)


## Parse source into lines with indentation info.
## Returns Array of {indent: int, code: String}.
func _parse_indented_lines(src: String) -> Array:
	var result := []
	var raw_lines := src.replace("\r\n", "\n").replace("\r", "\n").split("\n")

	for raw_line in raw_lines:
		# Calculate indentation level (assume 4 spaces per level)
		var indent_level := 0
		var i := 0
		while i < raw_line.length():
			if raw_line[i] == "\t":
				indent_level += 1
				i += 1
			elif raw_line[i] == " ":
				var spaces := 0
				while i < raw_line.length() and raw_line[i] == " ":
					spaces += 1
					i += 1
				indent_level += int(spaces / 4.0)
			else:
				break

		var code := raw_line.strip_edges()

		# Skip empty lines
		if code == "":
			continue

		# Handle semicolon-separated statements on same line
		if ";" in code:
			var statements := code.split(";")
			for stmt in statements:
				var stmt_clean := stmt.strip_edges()
				if stmt_clean != "":
					result.append({"indent": indent_level, "code": stmt_clean})
		else:
			result.append({"indent": indent_level, "code": code})

	return result


## Strip comments from source code whdwile preserving strings.
## [param src] Source code.
## [return] Source code with comments removed.
func _strip_comments(src: String) -> String:
	var result := ""
	var in_string := false
	var string_char := ""
	var i := 0

	while i < src.length():
		var c := src[i]

		# Handle string literals
		if c == '"' or c == "'":
			if not in_string:
				in_string = true
				string_char = c
				result += c
			elif c == string_char:
				# Check if escaped
				if i > 0 and src[i - 1] == "\\":
					result += c
				else:
					in_string = false
					result += c
			else:
				result += c
			i += 1
			continue

		# Skip if inside string
		if in_string:
			result += c
			i += 1
			continue

		# Check for comment
		if c == "#":
			# Skip until end of line
			while i < src.length() and src[i] != "\n":
				i += 1
			# Don't skip the newline itself, let it be added
			if i < src.length():
				result += "\n"
				i += 1
			continue

		result += c
		i += 1

	return result
