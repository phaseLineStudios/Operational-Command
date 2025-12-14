# DebugMenu::_property_to_option Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 390–455)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _property_to_option(node: Node, prop: Dictionary) -> Dictionary
```

## Description

Convert a property dictionary to a debug option dictionary

## Source

```gdscript
func _property_to_option(node: Node, prop: Dictionary) -> Dictionary:
	var prop_name: String = prop["name"]
	var prop_type: int = prop["type"]
	var prop_hint: int = prop.get("hint", 0)
	var prop_hint_string: String = prop.get("hint_string", "")

	var current_value = node.get(prop_name)
	var display_name := prop_name.replace("debug_", "").replace("_", " ").capitalize()
	var doc_comment := _get_property_doc_comment(node, prop_name)

	var option := {
		"name": display_name,
		"callback": func(value): node.set(prop_name, value),
		"tooltip": doc_comment
	}

	match prop_type:
		TYPE_BOOL:
			option["type"] = "bool"
			option["value"] = current_value

		TYPE_INT:
			option["type"] = "int"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_RANGE and prop_hint_string != "":
				var parts := prop_hint_string.split(",")
				if parts.size() >= 2:
					option["min"] = float(parts[0])
					option["max"] = float(parts[1])
					if parts.size() >= 3:
						option["step"] = float(parts[2])
			elif prop_hint == PROPERTY_HINT_ENUM and prop_hint_string != "":
				option["type"] = "enum"
				option["options"] = prop_hint_string.split(",")

		TYPE_FLOAT:
			option["type"] = "float"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_RANGE and prop_hint_string != "":
				var parts := prop_hint_string.split(",")
				if parts.size() >= 2:
					option["min"] = float(parts[0])
					option["max"] = float(parts[1])
					if parts.size() >= 3:
						option["step"] = float(parts[2])
					else:
						option["step"] = 0.01

		TYPE_STRING:
			option["type"] = "string"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_ENUM and prop_hint_string != "":
				option["type"] = "enum"
				option["options"] = prop_hint_string.split(",")

		TYPE_VECTOR2, TYPE_VECTOR3, TYPE_COLOR:
			option["type"] = "string"
			option["value"] = str(current_value)
			option["callback"] = func(_value): pass

		_:
			return {}

	return option
```
