# PickupItem::toggle_inspect Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 114–120)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func toggle_inspect(camera: Camera3D) -> void
```

## Source

```gdscript
func toggle_inspect(camera: Camera3D) -> void:
	if _inspecting:
		end_inspect()
	else:
		start_inspect(camera)
```
