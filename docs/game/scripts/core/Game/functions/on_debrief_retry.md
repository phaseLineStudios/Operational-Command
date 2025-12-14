# Game::on_debrief_retry Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 289–293)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func on_debrief_retry(_payload: Dictionary) -> void
```

## Description

Handle retry from debrief scene

## Source

```gdscript
func on_debrief_retry(_payload: Dictionary) -> void:
	# Reload the HQ table scene to restart the mission
	goto_scene("res://scenes/hq_table.tscn")
```
