# Debrief::_ready Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 87–131)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initializes node references, connects button handlers, prepares the Units tree,
draws the initial title, and aligns the right split after the first layout pass.

## Source

```gdscript
func _ready() -> void:
	_assert_nodes()
	_btn_retry.pressed.connect(_on_retry_pressed)
	_btn_continue.pressed.connect(_on_continue_pressed)
	_assign_btn.pressed.connect(_on_assign_pressed)
	_init_units_tree_columns()
	_update_title()

	if not Game.current_scenario_summary.is_empty():
		# @TODO: switch to using populate_from_dict()
		# @TODO: update summary return from missionresolution
		var summary = Game.current_scenario_summary
		set_mission_name(Game.current_scenario.title)
		set_outcome(MissionResolution.MissionOutcome.keys()[summary.get("outcome", 0)])

		var objectives: Dictionary = summary.get("objectives", {})
		var objective_states: Array[Dictionary] = []
		for key in objectives.keys():
			objective_states.append({"title": key, "completed": objectives.get(key, 2) == 1})
		set_objectives_results(objective_states)

		var score_breakdown: Dictionary = summary.get("score_breakdown", {})
		var base: int = score_breakdown.get("primary_success", 0)
		var bonus: int = (
			score_breakdown.get("friendly_casualties", 0)
			* score_breakdown.get("enemy_casualties", 0)
			* score_breakdown.get("units_lost", 0)
		)
		var penalty: int = score_breakdown.get("time_penalty_applied_on_finalize", 0)
		var total: int = summary.get("score_total", 0)
		set_score({"base": base, "bonus": bonus, "penalty": penalty, "total": total})
		#set_casualties(summary.get("casualties", {}))

		var units_dict: Array[Dictionary] = []
		var units_string: Array[String] = []
		for pu in Game.current_scenario.playable_units:
			units_dict.append({"name": pu.unit.title})
			units_string.append(pu.unit.title)
		set_units(units_dict)
		set_recipients_from_units()

	await get_tree().process_frame
	_align_right_split()
```
