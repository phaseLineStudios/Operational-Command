# ScenarioTriggersService::build_palette Function Reference

*Defined at:* `scripts/editors/services/ScenarioTriggersService.gd` (lines 5–18)</br>
*Belongs to:* [ScenarioTriggersService](../ScenarioTriggersService.md)

**Signature**

```gdscript
func build_palette(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func build_palette(ctx: ScenarioEditorContext) -> void:
	var list := ctx.trigger_list
	list.clear()
	var i := list.add_item("Trigger")
	var proto := ScenarioTrigger.new()
	proto.title = "Trigger"
	proto.area_size_m = Vector2(100.0, 100.0)
	list.set_item_metadata(i, proto)
	var img := proto.icon.get_image()
	img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
	list.set_item_icon(i, ImageTexture.create_from_image(img))
	list.item_selected.connect(func(idx): _on_selected(ctx, idx))
```
