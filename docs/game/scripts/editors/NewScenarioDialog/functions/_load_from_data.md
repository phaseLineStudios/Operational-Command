# NewScenarioDialog::_load_from_data Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 152–170)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _load_from_data(d: ScenarioData) -> void
```

## Description

Preload fields from existing ScenarioData.

## Source

```gdscript
func _load_from_data(d: ScenarioData) -> void:
	id_input.text = d.id
	title_input.text = d.title
	desc_input.text = d.description
	thumbnail = d.preview
	thumb_preview.texture = thumbnail
	terrain = d.terrain
	if ResourceLoader.exists(terrain.resource_path):
		terrain_path.text = terrain.resource_path
	else:
		terrain_path.text = ""
	_selected_units = []
	if d.unit_recruits:
		for u in d.unit_recruits:
			if u is UnitData:
				_selected_units.append(u)
	_refresh_unit_lists()
```
