# AmmoSystem::tick Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 125–137)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func tick(delta: float) -> void
```

## Description

Start links for needy units and transfer rounds along active links.

## Source

```gdscript
func tick(delta: float) -> void:
	for uid in _units.keys():
		if _active_links.has(uid):
			continue
		var dst: UnitData = _units[uid]
		if not _needs_ammo(dst):
			continue
		var src_id := _pick_link_for(dst)
		if src_id != "":
			_begin_link(src_id, uid)
	_transfer_tick(delta)
```
