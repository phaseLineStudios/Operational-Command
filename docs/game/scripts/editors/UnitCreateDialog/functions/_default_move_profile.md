# UnitCreateDialog::_default_move_profile Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 664–669)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _default_move_profile() -> int
```

## Description

Return default move profile.

## Source

```gdscript
func _default_move_profile() -> int:
	if typeof(TerrainBrush) != TYPE_NIL and "MoveProfile" in TerrainBrush:
		return int(TerrainBrush.MoveProfile.FOOT)
	return 0
```
