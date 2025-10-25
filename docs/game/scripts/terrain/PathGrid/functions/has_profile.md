# PathGrid::has_profile Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 742–745)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func has_profile(profile: int) -> bool
```

## Source

```gdscript
func has_profile(profile: int) -> bool:
	return _astar_cache.has(_astar_key(profile))
```
