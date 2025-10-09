# HQTable::_ready Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 18–26)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize mission systems and bind services.

## Source

```gdscript
func _ready() -> void:
	var playable_units := generate_playable_units(Game.current_scenario.unit_slots)
	Game.current_scenario.playable_units = playable_units
	map.init_terrain(Game.current_scenario)
	sim.init_world(Game.current_scenario)
	sim.bind_radio(%RadioController, %OrdersParser)
	wordlist.bind_recognizer(STTService.get_recognizer())
```
