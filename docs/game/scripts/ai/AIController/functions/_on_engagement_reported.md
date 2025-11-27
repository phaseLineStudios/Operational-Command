# AIController::_on_engagement_reported Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 284–332)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_engagement_reported(attacker_id: String, defender_id: String, _damage: float) -> void
```

## Description

SimWorld callback: mark defender as recently attacked and open return-fire window.

## Source

```gdscript
func _on_engagement_reported(attacker_id: String, defender_id: String, _damage: float) -> void:
	if Game.current_scenario == null:
		return
	var attacker_idx: int = int(_unit_index_cache.get(attacker_id, -1))
	var defender_idx: int = int(_unit_index_cache.get(defender_id, -1))
	if attacker_idx == -1 or defender_idx == -1:
		refresh_unit_index_cache()
		if attacker_idx == -1:
			attacker_idx = int(_unit_index_cache.get(attacker_id, -1))
		if defender_idx == -1:
			defender_idx = int(_unit_index_cache.get(defender_id, -1))

	# Allow RETURN_FIRE units to respond for a short window
	# defender_id maps to ScenarioUnit.id; our dictionary keys are unit indices, so search
	if defender_idx >= 0:
		var def_su: ScenarioUnit = Game.current_scenario.units[defender_idx]
		var key_def := "recently_attacked_" + String(attacker_id)
		def_su.set_meta(key_def, true)
		(
			_recent_attack_marks
			. append(
				{
					"uid": defender_idx,
					"key": key_def,
					"expire": (Time.get_ticks_msec() / 1000.0) + return_fire_window_sec,
				}
			)
		)
		var def_agent: AIAgent = _agents.get(defender_idx, null)
		if def_agent:
			def_agent.notify_hostile_shot()

	if attacker_idx >= 0:
		# Also mark the attacker so RETURN_FIRE from the defender will be allowed when roles swap
		var att_su: ScenarioUnit = Game.current_scenario.units[attacker_idx]
		var key_att := "recently_attacked_" + String(defender_id)
		att_su.set_meta(key_att, true)
		(
			_recent_attack_marks
			. append(
				{
					"uid": attacker_idx,
					"key": key_att,
					"expire": (Time.get_ticks_msec() / 1000.0) + return_fire_window_sec,
				}
			)
		)
```
