# VisibilityProfile::weather_severity_from_scenario Function Reference

*Defined at:* `scripts/data/VisibilityProfile.gd` (lines 55–70)</br>
*Belongs to:* [VisibilityProfile](../../VisibilityProfile.md)

**Signature**

```gdscript
func weather_severity_from_scenario(scenario_weather: Variant) -> float
```

## Description

Optional helper to derive weather severity from a ScenarioData.
Convert fog/rain into a 0..1 severity used by loss/visibility logic.

## Source

```gdscript
func weather_severity_from_scenario(scenario_weather: Variant) -> float:
	var fog_m: float = 8000.0
	var rain: float = 0.0
	if typeof(scenario_weather) == TYPE_DICTIONARY:
		fog_m = float(scenario_weather.get("fog_m", fog_m))
		rain = float(scenario_weather.get("rain", rain))
	elif scenario_weather != null:
		if "fog_m" in scenario_weather:
			fog_m = float(scenario_weather.fog_m)
		if "rain" in scenario_weather:
			rain = float(scenario_weather.rain)
	var fog_sev: float = clamp(1.0 - fog_m / 8000.0, 0.0, 1.0)
	var rain_sev: float = clamp(rain / 50.0, 0.0, 1.0)
	return max(fog_sev, rain_sev)
```
