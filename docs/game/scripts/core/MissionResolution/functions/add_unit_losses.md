# MissionResolution::add_unit_losses Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 210–211)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func add_unit_losses(uid: String, lost: int) -> void
```

## Source

```gdscript
func add_unit_losses(uid: String, lost: int) -> void:
	_losses_by_unit[uid] = max(0, int(_losses_by_unit.get(uid, 0)) + max(0, lost))
```
