# NewTerrainDialog::_window_title_and_cta Function Reference

*Defined at:* `scripts/editors/TerrainSettingsDialog.gd` (lines 115–119)</br>
*Belongs to:* [NewTerrainDialog](../../NewTerrainDialog.md)

**Signature**

```gdscript
func _window_title_and_cta() -> void
```

## Source

```gdscript
func _window_title_and_cta() -> void:
	title = "Edit Terrain" if _is_edit_mode else "Create New Terrain"
	create_btn.text = "Save" if _is_edit_mode else "Create"
```
