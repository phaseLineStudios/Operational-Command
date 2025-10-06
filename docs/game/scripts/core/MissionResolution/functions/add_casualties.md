# MissionResolution::add_casualties Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 73–81)</br>
*Belongs to:* [MissionResolution](../MissionResolution.md)

**Signature**

```gdscript
func add_casualties(friendly: int = 0, enemy: int = 0) -> void
```

## Description

Record casualties (aggregated).

## Source

```gdscript
func add_casualties(friendly: int = 0, enemy: int = 0) -> void:
	if _is_final:
		return
	_casualties.friendly += max(0, friendly)
	_casualties.enemy += max(0, enemy)
	_recompute_score()
	LogService.trace("Updated casualties", "MissionResolution.gd:76")
```
