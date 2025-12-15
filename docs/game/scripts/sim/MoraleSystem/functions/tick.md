# MoraleSystem::tick Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 71–86)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func tick(dt: float) -> void
```

## Description

applies overtime moralechanges

## Source

```gdscript
func tick(dt: float) -> void:
	if not scenario:
		return

	#idle
	if owner.move_state() == ScenarioUnit.MoveState.IDLE:
		apply_morale_delta(-0.0002 * dt, "idle_decay")
	safe_rest()
	if scenario.rain > 10.0:
		apply_morale_delta(-0.0004 * dt, "heavy_rain")
	if scenario.fog_m > 5000.0:
		apply_morale_delta(-0.0002 * dt, "dense_fog")
	if scenario.wind_speed_m > 15.0:
		apply_morale_delta(-0.0002 * dt, "high_winds")
```
