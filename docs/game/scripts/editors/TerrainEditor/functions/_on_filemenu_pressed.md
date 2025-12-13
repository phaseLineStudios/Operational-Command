# TerrainEditor::_on_filemenu_pressed Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 95–108)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _on_filemenu_pressed(id: int)
```

## Description

On file menu pressed event

## Source

```gdscript
func _on_filemenu_pressed(id: int):
	match id:
		0:
			_on_new_pressed()
		1:
			_open()
		2:
			_save()
		3:
			_save_as()
		4:
			_request_exit("menu")
```
