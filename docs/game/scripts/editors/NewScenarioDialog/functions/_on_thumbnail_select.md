# NewScenarioDialog::_on_thumbnail_select Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 81–104)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_thumbnail_select() -> void
```

## Source

```gdscript
func _on_thumbnail_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.png, *.jpg ; Images")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var res := Image.new()
			var err := res.load(path)
			if err == OK:
				var tex = ImageTexture.create_from_image(res)

				thumbnail = tex
				thumb_path.text = path
				thumb_preview.texture = tex
			else:
				push_error("Not an Image: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())
```
