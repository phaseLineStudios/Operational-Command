# PathGrid::ensure_profile Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 734–741)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func ensure_profile(profile: int) -> bool
```

## Source

```gdscript
func ensure_profile(profile: int) -> bool:
	if has_profile(profile):
		use_profile(profile)
		return true
	rebuild(profile)
	return false
```
