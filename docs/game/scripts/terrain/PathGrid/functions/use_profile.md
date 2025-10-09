# PathGrid::use_profile Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 728–733)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func use_profile(profile: int) -> void
```

## Source

```gdscript
func use_profile(profile: int) -> void:
	var key := _astar_key(profile)
	if _astar_cache.has(key):
		_astar = _astar_cache[key]
```
