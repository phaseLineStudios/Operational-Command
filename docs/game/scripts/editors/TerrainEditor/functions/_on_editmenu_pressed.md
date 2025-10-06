# TerrainEditor::_on_editmenu_pressed Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 108–117)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _on_editmenu_pressed(id: int)
```

## Description

On edit menu pressed event

## Source

```gdscript
func _on_editmenu_pressed(id: int):
	match id:
		0:
			terrain_settings_dialog.open_for_edit(data)
		1:
			history.undo()
		2:
			history.redo()
```
