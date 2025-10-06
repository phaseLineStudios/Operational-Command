# TerrainEditor::_open Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 414–432)</br>
*Belongs to:* [TerrainEditor](../TerrainEditor.md)

**Signature**

```gdscript
func _open()
```

## Description

Open terrain

## Source

```gdscript
func _open():
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres, *.res ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var res := ResourceLoader.load(path)
			if res is TerrainData:
				_new_terrain(res)
			else:
				push_error("Not a TerrainData: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
