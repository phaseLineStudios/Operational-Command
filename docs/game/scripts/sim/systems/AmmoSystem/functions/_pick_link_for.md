# AmmoSystem::_pick_link_for Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 183–197)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _pick_link_for(dst: UnitData) -> String
```

## Description

Pick a logistics source within radius that has stock (simple first-match).

## Source

```gdscript
func _pick_link_for(dst: UnitData) -> String:
	for sid in _units.keys():
		if sid == dst.id:
			continue
		if not _logi.get(sid, false):
			continue
		var src: UnitData = _units[sid]
		if not _has_stock(src):
			continue
		if not _within_radius(src, dst):
			continue
		return sid
	return ""
```
