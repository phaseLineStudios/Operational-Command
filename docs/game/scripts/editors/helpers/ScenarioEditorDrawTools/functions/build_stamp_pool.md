# ScenarioEditorDrawTools::build_stamp_pool Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd` (lines 31–52)</br>
*Belongs to:* [ScenarioEditorDrawTools](../../ScenarioEditorDrawTools.md)

**Signature**

```gdscript
func build_stamp_pool() -> void
```

## Description

Populate stamp list from terrain brush textures.

## Source

```gdscript
func build_stamp_pool() -> void:
	draw_textures.clear()
	draw_tex_paths.clear()
	editor.st_list.clear()

	var files := ResourceLoader.list_directory("res://assets/textures/stamps")
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["png", "webp", "jpg"]:
			var path := "res://assets/textures/stamps".path_join(file)
			var tex: Texture2D = load(path)
			if tex:
				var idx := editor.st_list.add_item(file.get_basename())
				var icon_img := tex.get_image()
				icon_img.resize(32, 32, Image.INTERPOLATE_LANCZOS)
				editor.st_list.set_item_icon(idx, ImageTexture.create_from_image(icon_img))
				editor.st_list.set_item_metadata(idx, {"path": path})
				draw_textures.append(tex)
				draw_tex_paths.append(path)
```
