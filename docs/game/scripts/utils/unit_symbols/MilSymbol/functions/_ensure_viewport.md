# MilSymbol::_ensure_viewport Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 202–228)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _ensure_viewport() -> void
```

## Description

Ensure viewport and renderer exist

## Source

```gdscript
func _ensure_viewport() -> void:
	if _viewport != null:
		return

	# Create viewport at higher resolution for anti-aliasing
	var target_size := config.get_pixel_size()
	var render_size := int(target_size * config.resolution_scale)

	_viewport = SubViewport.new()
	_viewport.size = Vector2i(render_size, render_size)
	_viewport.transparent_bg = true
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	# Create renderer
	_renderer = MilSymbolRenderer.new()
	_renderer.config = config
	_viewport.add_child(_renderer)

	# Add to scene tree (required for rendering)
	# Use call_deferred to avoid "busy setting up children" errors
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		tree.root.call_deferred("add_child", _viewport)
	else:
		push_error("MilSymbol: Cannot generate symbols without an active SceneTree")
```
