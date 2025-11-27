# TerrainEditor::_open Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 425–451)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

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
	dlg.add_filter("*.json ; JSON")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var f := FileAccess.open(path, FileAccess.READ)
			if f == null:
				return false
			var text := f.get_as_text()
			f.close()
			var parsed: Variant = JSON.parse_string(text)
			if typeof(parsed) != TYPE_DICTIONARY:
				return false
			var dta := TerrainData.deserialize(parsed)
			if dta != null:
				_new_terrain(dta)
			else:
				push_error("Not a TerrainData: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
