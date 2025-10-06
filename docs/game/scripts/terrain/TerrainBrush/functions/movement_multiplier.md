# TerrainBrush::movement_multiplier Function Reference

*Defined at:* `scripts/terrain/TerrainBrush.gd` (lines 88–101)</br>
*Belongs to:* [TerrainBrush](../TerrainBrush.md)

**Signature**

```gdscript
func movement_multiplier(profile: int) -> float
```

## Description

Returns the movement multiplier for a given profile.

## Source

```gdscript
func movement_multiplier(profile: int) -> float:
	match profile:
		MoveProfile.TRACKED:
			return mv_tracked
		MoveProfile.WHEELED:
			return mv_wheeled
		MoveProfile.FOOT:
			return mv_foot
		MoveProfile.RIVERINE:
			return mv_riverine
		_:
			return 1.0
```
