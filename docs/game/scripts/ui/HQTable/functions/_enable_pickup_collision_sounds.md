# HQTable::_enable_pickup_collision_sounds Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 301–308)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _enable_pickup_collision_sounds() -> void
```

## Description

Enable collision sounds for all PickupItems in the scene

## Source

```gdscript
func _enable_pickup_collision_sounds() -> void:
	var pickup_items := _find_all_pickup_items(self)
	for item in pickup_items:
		if item.has_method("enable_collision_sounds"):
			item.enable_collision_sounds()
	LogService.info("Enabled collision sounds for %d pickup items" % pickup_items.size(), "HQTable")
```
