# ScenarioEditorIDGenerator::get_callsign_pool Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd` (lines 132–153)</br>
*Belongs to:* [ScenarioEditorIDGenerator](../../ScenarioEditorIDGenerator.md)

**Signature**

```gdscript
func get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]
```

- **affiliation**: Unit affiliation (FRIEND or ENEMY).
- **Return Value**: Array of available callsign strings.

## Description

Get callsign pool for faction (uses defaults if scenario lacks overrides).

## Source

```gdscript
func get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]:
	var pool: Array[String]
	if affiliation == ScenarioUnit.Affiliation.FRIEND:
		if (
			editor.data
			and editor.data.friendly_callsigns
			and editor.data.friendly_callsigns.size() > 0
		):
			pool = editor.data.friendly_callsigns
		else:
			pool = DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if editor.data and editor.data.enemy_callsigns and editor.data.enemy_callsigns.size() > 0:
			pool = editor.data.enemy_callsigns
		else:
			pool = DEFAULT_ENEMY_CALLSIGNS
	var out: Array[String] = []
	for v in pool:
		out.append(str(v))
	return out
```
