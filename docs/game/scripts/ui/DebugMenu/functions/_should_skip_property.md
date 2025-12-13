# DebugMenu::_should_skip_property Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 273–286)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _should_skip_property(prop_name: String) -> bool
```

## Description

Check if we should skip this property

## Source

```gdscript
func _should_skip_property(prop_name: String) -> bool:
	const SKIP_PROPERTIES := [
		"debug_draw",
		"physics_material_override",
		"input_pickable",
		"canvas_cull_mask",
	]

	if prop_name.begins_with("script_") or prop_name.begins_with("metadata_"):
		return true

	return prop_name in SKIP_PROPERTIES
```
