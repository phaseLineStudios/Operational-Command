# Game::on_debrief_continue Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 277–287)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func on_debrief_continue(_payload: Dictionary) -> void
```

## Description

Handle continue from debrief scene

## Source

```gdscript
func on_debrief_continue(_payload: Dictionary) -> void:
	# Save campaign state with experience updates
	if current_save:
		save_campaign_state()
		Persistence.save_to_file(current_save)

	# Navigate to campaign/mission select or next mission
	# For now, go back to mission select
	goto_scene("res://scenes/mission_select.tscn")
```
