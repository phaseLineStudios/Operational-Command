# ScenarioEditor::_get_callsign_pool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 815–832)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]
```

## Description

Get callsign pool for faction (uses defaults if scenario lacks overrides)

## Source

```gdscript
func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]:
	var pool: Array[String]
	if affiliation == ScenarioUnit.Affiliation.FRIEND:
		if data and data.friendly_callsigns and data.friendly_callsigns.size() > 0:
			pool = data.friendly_callsigns
		else:
			pool = DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if data and data.enemy_callsigns and data.enemy_callsigns.size() > 0:
			pool = data.enemy_callsigns
		else:
			pool = DEFAULT_ENEMY_CALLSIGNS
	var out: Array[String] = []
	for v in pool:
		out.append(str(v))
	return out
```
