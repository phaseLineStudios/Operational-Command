# HQTable::_init_drawing_controller Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 76–84)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_drawing_controller() -> void
```

## Description

Initialize the drawing controller and bind to trigger API

## Source

```gdscript
func _init_drawing_controller() -> void:
	if drawing_controller:
		# Set the map mesh reference
		drawing_controller.map_mesh = %Map

	if trigger_engine and trigger_engine._api:
		trigger_engine._api.drawing_controller = drawing_controller
```
