# AIController::_physics_process Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 334–356)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _physics_process(dt: float) -> void
```

## Description

Tick all runners (fixed step) and clear expired return-fire marks.

## Source

```gdscript
func _physics_process(dt: float) -> void:
	# Sweep and clear expired "recently_attacked_*" marks
	if not _recent_attack_marks.is_empty():
		var now := Time.get_ticks_msec() / 1000.0
		for i in range(_recent_attack_marks.size() - 1, -1, -1):
			var rec: Dictionary = _recent_attack_marks[i]
			if float(rec.get("expire", 0.0)) <= now:
				var idx := int(rec.get("uid", -1))
				var k: String = String(rec.get("key", ""))
				if idx >= 0 and Game.current_scenario and Game.current_scenario.units.size() > idx:
					var su: ScenarioUnit = Game.current_scenario.units[idx]
					if su and su.has_meta(k):
						su.remove_meta(k)
				_recent_attack_marks.remove_at(i)

	for uid in _runners.keys():
		var runner: ScenarioTaskRunner = _runners[uid]
		var agent: AIAgent = _agents.get(uid, null)
		if agent == null:
			continue
		runner.tick(dt, agent)
```
