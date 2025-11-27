# AIAgent::_apply_behaviour_mapping Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 107–141)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func _apply_behaviour_mapping() -> void
```

## Source

```gdscript
func _apply_behaviour_mapping() -> void:
	var speed_mult: float = 1.0
	var cover_bias: float = 0.5
	var noise_level: float = 0.6

	match behaviour:
		Behaviour.CARELESS:
			speed_mult = 1.25
			cover_bias = 0.2
			noise_level = 1.0
		Behaviour.SAFE:
			speed_mult = 1.0
			cover_bias = 0.5
			noise_level = 0.6
		Behaviour.AWARE:
			speed_mult = 0.85
			cover_bias = 0.8
			noise_level = 0.4
		Behaviour.COMBAT:
			speed_mult = 0.75
			cover_bias = 0.9
			noise_level = 0.5
		Behaviour.STEALTH:
			speed_mult = 0.6
			cover_bias = 1.0
			noise_level = 0.2

	if _movement != null and _movement.has_method("set_behaviour_params"):
		_movement.set_behaviour_params(speed_mult, cover_bias, noise_level)
	# Also pass speed multiplier to the ScenarioUnit for pathing speed
	var su := _get_su()
	if su:
		su.set_meta("behaviour_speed_mult", speed_mult)
```
