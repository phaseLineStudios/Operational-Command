# ScenarioData::serialize Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 97–164)</br>
*Belongs to:* [ScenarioData](../../ScenarioData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize data to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	var recruit_ids: Array = []
	for u in unit_recruits:
		if u is UnitData and u.id != null and String(u.id) != "":
			recruit_ids.append(String(u.id))

	var placed_units: Array = []
	for unit in units:
		if unit is ScenarioUnit:
			placed_units.append(unit.serialize())

	var placed_triggers: Array = []
	for trigger in triggers:
		if trigger is ScenarioTrigger:
			placed_triggers.append(trigger.serialize())

	var placed_tasks: Array = []
	for task in tasks:
		if task is ScenarioTask:
			placed_tasks.append(task.serialize())

	var placed_drawings: Array = []
	for d in drawings:
		if d is ScenarioDrawing:
			placed_drawings.append(d.serialize())

	var placed_custom_commands: Array = []
	for cmd in custom_commands:
		if cmd is CustomCommand:
			placed_custom_commands.append(cmd.serialize())

	return {
		"id": id,
		"title": title,
		"description": description,
		"preview_path": preview_path,
		"video_path": video_path,
		"video_subtitles":
		video_subtitles.serialize() as Variant if video_subtitles else null as Variant,
		"terrain_id": terrain.terrain_id,
		"briefing": briefing.serialize() as Variant if briefing else null as Variant,
		"difficulty": int(difficulty),
		"map_position": _vec2_to_dict(map_position),
		"scenario_order": scenario_order,
		"weather":
		{"rain": rain, "fog_m": fog_m, "wind_dir": wind_dir, "wind_speed_m": wind_speed_m},
		"datetime": {"year": year, "month": month, "day": day, "hour": hour, "minute": minute},
		"units":
		{
			"unit_points": unit_points,
			"unit_slots": _serialize_unit_slots(unit_slots),
			"unit_recruits_ids": recruit_ids,
			"unit_reserves": _serialize_unit_slots(unit_reserves),
			"replacement_pool": replacement_pool,
			"equipment_pool": equipment_pool,
			"ammo_pools": ammo_pools.duplicate()
		},
		"content":
		{
			"units": placed_units,
			"triggers": placed_triggers,
			"tasks": placed_tasks,
			"drawings": placed_drawings,
			"custom_commands": placed_custom_commands
		}
	}
```
