# TerrainEditor::_on_new_pressed Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 119–122)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _on_new_pressed()
```

## Description

On New Terrain Pressed event

## Source

```gdscript
func _on_new_pressed():
	terrain_settings_dialog.open_for_create("New Terrain", 2000, 2000, 100, 100, 113)
```
