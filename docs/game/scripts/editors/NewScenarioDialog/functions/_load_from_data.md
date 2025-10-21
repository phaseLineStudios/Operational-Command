# NewScenarioDialog::_load_from_data Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 126–137)</br>
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
	title_input.text = d.title
	desc_input.text = d.description
	thumbnail = d.preview
	thumb_preview.texture = thumbnail
	terrain = d.terrain
	if ResourceLoader.exists(terrain.resource_path):
		terrain_path.text = terrain.resource_path
	else:
		terrain_path.text = ""
```
