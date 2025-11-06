# DebugMenu::_extract_debug_exports Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 302–350)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _extract_debug_exports(node: Node) -> Array
```

## Description

Extract debug-related @export variables from a node

## Source

```gdscript
func _extract_debug_exports(node: Node) -> Array:
	var options: Array = []
	var properties := node.get_property_list()
	var in_debug_category := false
	var in_debug_group := false

	for prop in properties:
		var prop_name: String = prop["name"]
		var prop_usage: int = prop["usage"]

		# Track categories and groups
		if prop_usage & PROPERTY_USAGE_CATEGORY:
			in_debug_category = prop_name.to_lower().contains("debug")
			continue

		if prop_usage & PROPERTY_USAGE_GROUP:
			in_debug_group = prop_name.to_lower().contains("debug")
			continue

		# Skip non-editor properties
		if not (prop_usage & PROPERTY_USAGE_EDITOR):
			continue

		# Skip built-in properties
		if prop_usage & PROPERTY_USAGE_CLASS_IS_BITFIELD:
			continue

		# Check if this is a debug property
		var is_debug := false
		if prop_name.to_lower().contains("debug"):
			is_debug = true
		elif in_debug_category or in_debug_group:
			is_debug = true

		if not is_debug:
			continue

		# Skip unwanted built-in properties
		if _should_skip_property(prop_name):
			continue

		# Convert property to debug option
		var option := _property_to_option(node, prop)
		if option != null and not option.is_empty():
			options.append(option)

	return options
```
