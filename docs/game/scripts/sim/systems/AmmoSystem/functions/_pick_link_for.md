# AmmoSystem::_pick_link_for Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 203–223)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String
```

## Description

Pick a logistics source within radius that has stock (simple first-match).

## Source

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String:
	for sid in _units.keys():
		if sid == dst.id:
			continue
		if not _logi.get(sid, false):
			continue
		var src: ScenarioUnit = _units[sid]
		# Don't use dead units as suppliers
		if src.state_strength <= 0:
			continue
		# Only use stationary units as suppliers
		if src.move_state() != ScenarioUnit.MoveState.IDLE:
			continue
		if not _has_stock(src):
			continue
		if not _within_radius(src, dst):
			continue
		return sid
	return ""
```
