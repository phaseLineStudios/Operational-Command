# AmmoTest::_embed_rearm_panel Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 229–261)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _embed_rearm_panel() -> void
```

## Source

```gdscript
func _embed_rearm_panel() -> void:
	# Create a horizontal frame and move your existing UI under it,
	# then add the rearm panel on the left.
	var frame := HBoxContainer.new()
	frame.name = "Frame"
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Grab your current UI node and reparent under the frame
	var ui := $UI
	remove_child(ui)
	add_child(frame)

	# Instance the panel and add it on the left
	_rearm_panel = preload("res://scenes/ui/ammo_rearm_panel.tscn").instantiate() as AmmoRearmPanel
	_rearm_panel.custom_minimum_size = Vector2(300, 0)  # width of the side panel
	_rearm_panel.size_flags_stretch_ratio = 0.28  # keep it slim vs. the main UI

	frame.add_child(_rearm_panel)
	frame.add_child(ui)

	# Ensure the right UI fills remaining space
	ui.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Feed roster + a placeholder depot stock to the panel
	# (use your real mission depot dict if you have one)
	_rearm_panel.load_units([shooter, logi], {"small_arms": 300})

	# When the user commits, update HUD and (optionally) save
	_rearm_panel.rearm_committed.connect(_on_rearm_committed)
```
