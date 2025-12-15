# HQTable::_update_subtitle_suggestions Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 406–426)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _update_subtitle_suggestions(scenario: ScenarioData) -> void
```

## Description

Update subtitle suggestions with terrain labels and unit callsigns

## Source

```gdscript
func _update_subtitle_suggestions(scenario: ScenarioData) -> void:
	var labels: Array[String] = []
	if scenario.terrain and scenario.terrain.labels:
		for label_data in scenario.terrain.labels:
			var label_text := str(label_data.get("text", ""))
			if label_text != "":
				labels.append(label_text)

	var callsigns: Array[String] = []
	var all_units := []
	all_units.append_array(scenario.playable_units)
	all_units.append_array(scenario.units)

	for unit in all_units:
		if unit and unit.callsign != "":
			callsigns.append(unit.callsign)

	radio_subtitles.set_terrain_labels(labels)
	radio_subtitles.set_unit_callsigns(callsigns)
```
