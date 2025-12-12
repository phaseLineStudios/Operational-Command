# LOSAdapter::_current_weather_severity Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 198–208)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _current_weather_severity() -> float
```

## Source

```gdscript
func _current_weather_severity() -> float:
	# If a terrain renderer data is attached, try to fetch ScenarioData weather if present.
	# Fallback to 0 severity.
	if Game.current_scenario != null:
		var scen: ScenarioData = Game.current_scenario
		var fog_m: float = float(scen.fog_m)
		var rain: float = float(scen.rain)
		var fog_sev: float = clamp(1.0 - fog_m / 8000.0, 0.0, 1.0)
		var rain_sev: float = clamp(rain / 50.0, 0.0, 1.0)
		return max(fog_sev, rain_sev)
	return 0.0
```
