# TerrainEffects::weather_severity_from_scenario Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 112–119)</br>
*Belongs to:* [TerrainEffects](../TerrainEffects.md)

**Signature**

```gdscript
func weather_severity_from_scenario(s: ScenarioData) -> float
```

## Description

Derive 0..1 weather severity from ScenarioData (fog/rain).

## Source

```gdscript
static func weather_severity_from_scenario(s: ScenarioData) -> float:
	if s == null:
		return 0.0
	var fog: float = clamp(1.0 - float(s.fog_m) / 8000.0, 0.0, 1.0)
	var rain: float = clamp(float(s.rain) / 50.0, 0.0, 1.0)
	return clamp(max(fog, rain), 0.0, 1.0)
```
