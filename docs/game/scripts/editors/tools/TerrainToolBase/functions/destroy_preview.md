# TerrainToolBase::destroy_preview Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 106–109)</br>
*Belongs to:* [TerrainToolBase](../../TerrainToolBase.md)

**Signature**

```gdscript
func destroy_preview() -> void
```

## Description

Destroy the preview

## Source

```gdscript
func destroy_preview() -> void:
	if is_instance_valid(_preview):
		_preview.queue_free()
	_preview = null
```
