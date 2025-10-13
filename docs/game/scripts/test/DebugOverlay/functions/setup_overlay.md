# DebugOverlay::setup_overlay Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 28–43)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void
```

## Description

Set up overlay with renderer and the two scenario units [attacker, defender].

## Source

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void:
	_renderer = renderer

	# Copy/cast into a typed array so we can assign to `_units: Array[ScenarioUnit]`
	var typed: Array[ScenarioUnit] = []
	typed.resize(units.size())
	for i in range(units.size()):
		typed[i] = units[i] as ScenarioUnit
	_units = typed

	if _fuel == null:
		_fuel = get_tree().get_first_node_in_group("FuelSystem") as FuelSystem

	queue_redraw()
```
