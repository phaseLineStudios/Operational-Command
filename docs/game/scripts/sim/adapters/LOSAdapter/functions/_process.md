# LOSAdapter::_process Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 59–74)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
	if _actor == null:
		return
	if String(hostiles_group_name) == "":
		return
	# Simple proximity scan; replace with your perception logic when ready
	var pos: Vector3 = _actor.global_position
	var found: bool = false
	for n in get_tree().get_nodes_in_group(hostiles_group_name):
		if n is Node3D:
			if (n as Node3D).global_position.distance_to(pos) <= detection_radius:
				found = true
				break
	_hostile_contact = found
```
