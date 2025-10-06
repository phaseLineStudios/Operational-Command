# NewScenarioDialog::_on_terrain_select Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 61–80)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

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
	dlg.add_filter("*.tres, *.res ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var res := ResourceLoader.load(path)
			if res is TerrainData:
				terrain = res
				terrain_path.text = path
			else:
				push_error("Not a TerrainData: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
