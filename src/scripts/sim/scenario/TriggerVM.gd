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
## [param expr_src] Expression source.
## [param ctx] becomes constants accessible in the expression.
func run(expr_src: String, ctx: Dictionary) -> void:
	LogService.trace("Ran trigger expression", "TriggerVM.gd:49")
	var src := expr_src.strip_edges()
	if src == "":
		return
	for line in _split_lines(src):
		var compiled := _compile(line, ctx)
		if compiled == null or compiled.is_empty():
			continue
		var inputs := _values_for(compiled.names, ctx)
		compiled.expr.execute(inputs, _api, false, false)


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


## Split source by lines.
## [param src] Source string.
## [return] PackedStringArray of code lines.
func _split_lines(src: String) -> PackedStringArray:
	var work := src.replace("\r", "\n").split("\n", false)
	var out := PackedStringArray()
	for s in work:
		var parts := s.split(";", false)
		for p in parts:
			var t := p.strip_edges()
			if t != "":
				out.append(t)
	return out
