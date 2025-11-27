# SimDebugOverlay::_rebuild_id_index Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 158–170)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _rebuild_id_index() -> void
```

## Description

Build unit_id -> ScenarioUnit lookup from the current scenario.

## Source

```gdscript
func _rebuild_id_index() -> void:
	_unit_by_id.clear()
	var scen := Game.current_scenario
	if scen == null:
		return
	for su in scen.units:
		if su != null:
			_unit_by_id[su.id] = su
	for su in scen.playable_units:
		if su != null:
			_unit_by_id[su.id] = su
```
