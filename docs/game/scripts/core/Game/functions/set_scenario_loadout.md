# Game::set_scenario_loadout Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 210–214)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func set_scenario_loadout(loadout: Dictionary) -> void
```

## Description

Set current mission loadout and emit `signal mission_loadout_selected`

## Source

```gdscript
func set_scenario_loadout(loadout: Dictionary) -> void:
	current_scenario_loadout = loadout
	emit_signal("scenario_loadout_selected", loadout)
```

## References

- [`signal mission_loadout_selected`](../../Game.md)
