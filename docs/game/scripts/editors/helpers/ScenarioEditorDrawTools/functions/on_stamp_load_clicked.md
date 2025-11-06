# ScenarioEditorDrawTools::on_stamp_load_clicked Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 195–215)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func on_stamp_load_clicked() -> void
```

## Description

Load a texture from disk into pool.

## Source

```gdscript
func on_stamp_load_clicked() -> void:
	var fd := FileDialog.new()
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fd.access = FileDialog.ACCESS_RESOURCES
	fd.filters = PackedStringArray(["*.png,*.webp,*.jpg ; Images"])
	fd.title = "Select Texture"
	editor.add_child(fd)
	fd.file_selected.connect(
		func(p: String):
			var t: Texture2D = load(p)
			if t:
				var idx := editor.st_list.add_item(p.get_file())
				var icon_img := t.get_image()
				icon_img.resize(32, 32, Image.INTERPOLATE_LANCZOS)
				editor.st_list.set_item_icon(idx, ImageTexture.create_from_image(icon_img))
				editor.st_list.set_item_metadata(idx, {"path": p})
			fd.queue_free()
	)
	fd.popup_centered_ratio(0.6)
```
