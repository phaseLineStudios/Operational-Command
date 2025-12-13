# NewScenarioDialog::_on_terrain_select Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 113–140)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_terrain_select() -> void
```

## Source

```gdscript
func _on_terrain_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.json, *.json ; TerrainData")
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
				terrain = dta
				terrain_path.text = path
			else:
				push_error("Not a TerrainData: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
