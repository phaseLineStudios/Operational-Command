# Game::end_scenario_and_go_to_debrief Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 118–139)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func end_scenario_and_go_to_debrief() -> void
```

## Description

End mission and navigate to debrief

## Source

```gdscript
func end_scenario_and_go_to_debrief() -> void:
	current_scenario_summary = resolution.finalize(false)

	# If you have a per-unit losses map, apply it now
	var losses: Dictionary = {}
	# Preferred: pull from your sim/resolution if you track it
	# e.g. losses = resolution.get_losses_by_unit_id()  # { "ALPHA": 3, ... }
	# Or if finalize() summary contains it, use that:
	if current_scenario_summary.has("losses_by_unit"):
		losses = current_scenario_summary["losses_by_unit"]

	if not losses.is_empty():
		# Apply to campaign units so UnitMgmt reflects new strengths
		resolution.apply_casualties_to_units(Game.current_scenario.units, losses)

	# Persist (added later)
	if has_method("save_campaign_state"):
		save_campaign_state()

	goto_scene("res://scenes/debrief.tscn")
```
