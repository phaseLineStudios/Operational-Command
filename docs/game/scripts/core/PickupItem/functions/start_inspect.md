# PickupItem::start_inspect Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 68–76)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func start_inspect(camera: Camera3D) -> void
```

## Description

Runs on inspect start

## Source

```gdscript
func start_inspect(camera: Camera3D) -> void:
	if _inspecting:
		return
	_inspecting = true
	_inspect_camera = camera
	_pre_inspect_transform = global_transform
	freeze = true
```
