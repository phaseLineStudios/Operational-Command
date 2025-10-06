# Game::select_scenario Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 59–63)</br>
*Belongs to:* [Game](../Game.md)

**Signature**

```gdscript
func select_scenario(scenario: ScenarioData) -> void
```

## Description

Set current mission and emit `signal mission_selected`.

## Source

```gdscript
func select_scenario(scenario: ScenarioData) -> void:
	current_scenario = scenario
	emit_signal("scenario_selected", scenario.id)
```

## References

- [`signal mission_selected`](..\..\Game.md#mission_selected)
