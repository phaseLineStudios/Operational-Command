# HQTable::_init_counter_controller Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 111–118)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_counter_controller() -> void
```

## Description

Initialize the counter controller and bind to trigger API

## Source

```gdscript
func _init_counter_controller() -> void:
	if counter_controller and map:
		counter_controller.init(%Map, map.renderer)

	if trigger_engine and trigger_engine._api:
		trigger_engine._api._counter_controller = counter_controller
```
