# TerrainBrush::defensive_modifiers Function Reference

*Defined at:* `scripts/terrain/TerrainBrush.gd` (lines 108–111)</br>
*Belongs to:* [TerrainBrush](../../TerrainBrush.md)

**Signature**

```gdscript
func defensive_modifiers() -> Dictionary
```

## Description

Returns a simple defensive modifier bundle for Combat.gd.

## Source

```gdscript
func defensive_modifiers() -> Dictionary:
	return {"cover_reduction": cover_reduction, "concealment": concealment}
```
