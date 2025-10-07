# Game::end_scenario_and_go_to_debrief Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 105–107)</br>
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
	goto_scene("res://scenes/debrief.tscn")
```
