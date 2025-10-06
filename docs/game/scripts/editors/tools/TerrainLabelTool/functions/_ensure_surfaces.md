# TerrainLabelTool::_ensure_surfaces Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 168–174)</br>
*Belongs to:* [TerrainLabelTool](../TerrainLabelTool.md)

**Signature**

```gdscript
func _ensure_surfaces()
```

## Source

```gdscript
func _ensure_surfaces():
	if data == null:
		return
	if !("surfaces" in data) or data.labels == null:
		data.labels = []
```
