# TriggerEngine::_refresh_unit_indices Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 48–64)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _refresh_unit_indices() -> void
```

## Description

Refresh unit indices.

## Source

```gdscript
func _refresh_unit_indices() -> void:
	_snap_by_id.clear()
	_id_by_callsign.clear()
	_player_ids.clear()

	if _sim:
		for s in _sim.get_unit_snapshots():
			var id := str(s.get("id", ""))
			_snap_by_id[id] = s
			_id_by_callsign[str(s.get("callsign", ""))] = id

	var pm := _scenario.playable_units
	for su in pm:
		if su:
			_player_ids[str(su.id)] = true
```
