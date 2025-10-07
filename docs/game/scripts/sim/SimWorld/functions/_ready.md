# SimWorld::_ready Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 20–38)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Create and configure AmmoSystem; optionally hook up RadioFeedback.

## Source

```gdscript
func _ready() -> void:
	add_child(_ammo)
	_ammo.ammo_profile = preload("res://data/ammo/default_caps.tres")

	add_child(_adapter)
	_adapter.add_to_group("CombatAdapter")
	_adapter.ammo_system_path = _ammo.get_path()
	# Register units once roster is ready (left commented for now; call from roster code):
	# for u in _current_units:
	#     _ammo.register_unit(u)

	# Optional radio hookup (if a RadioFeedback node exists in the scene).
	var radio := get_tree().get_first_node_in_group("RadioFeedback") as RadioFeedback
	if radio:
		radio.bind_ammo(_ammo)

	Game.start_scenario([])
```
