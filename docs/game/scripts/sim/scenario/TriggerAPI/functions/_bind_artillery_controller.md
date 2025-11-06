# TriggerAPI::_bind_artillery_controller Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 804–808)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _bind_artillery_controller(artillery_ctrl: ArtilleryController) -> void
```

- **artillery_ctrl**: ArtilleryController reference.

## Description

Bind to ArtilleryController to track fire missions (internal, called by TriggerEngine).

## Source

```gdscript
func _bind_artillery_controller(artillery_ctrl: ArtilleryController) -> void:
	if artillery_ctrl and not artillery_ctrl.mission_confirmed.is_connected(_on_artillery_called):
		artillery_ctrl.mission_confirmed.connect(_on_artillery_called)
```
