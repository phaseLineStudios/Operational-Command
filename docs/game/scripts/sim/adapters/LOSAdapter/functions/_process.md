# LOSAdapter::_process Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 66–93)</br>
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

	_scan_accum += _dt
	var interval: float = maxf(proximity_scan_interval_sec, 0.0)
	if interval > 0.0 and _scan_accum < interval:
		return
	_scan_accum = 0.0

	# Simple proximity scan; replace with your perception logic when ready.
	var pos: Vector3 = _actor.global_position
	var radius_sq: float = detection_radius * detection_radius
	var found: bool = false
	for n in get_tree().get_nodes_in_group(hostiles_group_name):
		var n3d: Node3D = n as Node3D
		if n3d == null:
			continue
		if n3d.global_position.distance_squared_to(pos) <= radius_sq:
			found = true
			break
	_hostile_contact = found
	if found:
		_last_contact_s = Time.get_ticks_msec() / 1000.0
```
