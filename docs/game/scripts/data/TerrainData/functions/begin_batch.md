# TerrainData::begin_batch Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 97–100)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func begin_batch() -> void
```

## Description

Begin a batch - defers granular signals until end_batch().

## Source

```gdscript
func begin_batch() -> void:
	_batch_depth += 1
```
