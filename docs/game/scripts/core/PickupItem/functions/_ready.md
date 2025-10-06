# PickupItem::_ready Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 35–40)</br>
*Belongs to:* [PickupItem](../PickupItem.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	collision_layer = 2
	origin_position = global_transform.origin
	origin_rotation = global_rotation
```
