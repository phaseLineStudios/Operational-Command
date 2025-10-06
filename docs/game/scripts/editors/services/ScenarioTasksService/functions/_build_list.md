# ScenarioTasksService::_build_list Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 24–37)</br>
*Belongs to:* [ScenarioTasksService](../ScenarioTasksService.md)

**Signature**

```gdscript
func _build_list(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _build_list(ctx: ScenarioEditorContext) -> void:
	var list := ctx.task_list
	list.clear()
	for i in defs.size():
		var t: UnitBaseTask = defs[i]
		if t.icon:
			var img := t.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			list.add_item(t.display_name, ImageTexture.create_from_image(img))
		else:
			list.add_item(t.display_name)
		list.set_item_metadata(i, t)
```
