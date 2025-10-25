# DebugOverlay::_format_fuel_line Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 261–266)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func _format_fuel_line(atk: ScenarioUnit, def: ScenarioUnit) -> String
```

## Source

```gdscript
func _format_fuel_line(atk: ScenarioUnit, def: ScenarioUnit) -> String:
	var atk_s := _fuel_snapshot(atk)
	var def_s := _fuel_snapshot(def)
	return "FUEL atk %s | def %s" % [atk_s, def_s]
```
