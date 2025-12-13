# Settings::_reset_all_bindings Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 256–267)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _reset_all_bindings() -> void
```

## Description

Remove custom bindings and restore defaults (uses InputSchema if present).

## Source

```gdscript
func _reset_all_bindings() -> void:
	if Engine.has_singleton("InputSchema"):
		var schema := Engine.get_singleton("InputSchema")
		if schema and schema.has_method("reset_to_defaults"):
			schema.call("reset_to_defaults")
	# Update button labels
	for node in _controls_list.get_children():
		for child in (node as HBoxContainer).get_children():
			if child is Button and child.has_method("refresh_label"):
				child.call("refresh_label")
```
