# NewScenarioDialog::_ready Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 28–36)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)
```
