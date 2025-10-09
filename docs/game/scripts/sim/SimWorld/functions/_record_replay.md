# SimWorld::_record_replay Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 183–193)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _record_replay() -> void
```

## Description

Records a compact snapshot for replays.

## Source

```gdscript
func _record_replay() -> void:
	var snap := {"tick": _tick_idx, "units": {}}
	for su in _friendlies + _enemies:
		snap.units[su.id] = {
			"pos": su.position_m,
			"state": su.move_state(),
			"morale": su.unit.morale if su.unit else 1.0
		}
	_replay.append(snap)
```
