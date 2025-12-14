# FuelSystem::fuel_debug Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 485–500)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func fuel_debug(uid: String) -> Dictionary
```

## Description

Compact UI snapshot for overlays / panels.

## Source

```gdscript
func fuel_debug(uid: String) -> Dictionary:
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null:
		return {"percent": null, "state": "n/a", "mult": 1.0, "penalty_pct": 0}
	var pct: int = int(round(st.ratio() * 100.0))
	var tag := "NORMAL"
	if is_empty(uid):
		tag = "EMPTY"
	elif is_critical(uid):
		tag = "CRITICAL"
	elif is_low(uid):
		tag = "LOW"
	var mult: float = speed_mult(uid)
	return {
		"percent": pct, "state": tag, "mult": mult, "penalty_pct": int(round((1.0 - mult) * 100.0))
	}
```
