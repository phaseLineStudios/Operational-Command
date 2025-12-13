# Game::get_current_units Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 234–246)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func get_current_units() -> Array
```

## Description

Return current units in context for screens that need them.
Prefer Scenario.playable_units entries, but fall back to unit_recruits.

## Source

```gdscript
func get_current_units() -> Array:
	var out: Array = []
	if current_scenario:
		for su in current_scenario.playable_units:
			if su and su.unit:
				out.append(su)
		if out.is_empty():
			for u in current_scenario.unit_recruits:
				if u:
					out.append(u)
	return out
```
