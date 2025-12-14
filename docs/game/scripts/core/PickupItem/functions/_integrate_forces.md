# PickupItem::_integrate_forces Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 285–296)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void
```

## Description

Integrate forces to detect collisions reliably

## Source

```gdscript
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var contact_count := state.get_contact_count()
	if contact_count > 0:
		var max_impulse := 0.0
		for i in contact_count:
			var impulse := state.get_contact_impulse(i).length()
			if impulse > max_impulse:
				max_impulse = impulse

		_last_impact_impulse = max(max_impulse, _last_impact_impulse)
```
