# NewTerrainDialog::_ready Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 23–28)</br>
*Belongs to:* [NewTerrainDialog](../NewTerrainDialog.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	cancel_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
```
