# TerrainToolBase::ensure_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 59–63)</br>
*Belongs to:* [TerrainToolBase](../TerrainToolBase.md)

**Signature**

```gdscript
func ensure_preview(parent: Control) -> void
```

## Description

Ensure the preview exists

## Source

```gdscript
func ensure_preview(parent: Control) -> void:
	if _preview == null:
		_preview = build_preview(parent)
```
