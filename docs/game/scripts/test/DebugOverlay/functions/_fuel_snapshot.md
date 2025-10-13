# DebugOverlay::_fuel_snapshot Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 271–291)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func _fuel_snapshot(su: ScenarioUnit) -> String
```

## Description

Build "68% LOW x0.85 (-15%)" style snippets per unit.

## Source

```gdscript
func _fuel_snapshot(su: ScenarioUnit) -> String:
	if su == null or _fuel == null:
		return "n/a x1.00 (-0%)"
	var st: UnitFuelState = _fuel.get_fuel_state(su.id)
	if st == null:
		return "n/a x1.00 (-0%)"

	var pct: int = int(round(st.ratio() * 100.0))
	var mult: float = _fuel.speed_mult(su.id)
	var pen: int = int(round((1.0 - mult) * 100.0))
	var tag := "OK"
	if _fuel.is_empty(su.id):
		tag = "EMPTY"
	elif _fuel.is_critical(su.id):
		tag = "CRIT"
	elif _fuel.is_low(su.id):
		tag = "LOW"

	return "%d%% %s x%.2f (-%d%%)" % [pct, tag, mult, pen]
```
