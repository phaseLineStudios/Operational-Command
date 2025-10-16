# HQTable::_ready Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 19–30)</br>
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
	var scenario = Game.current_scenario
	var playable_units := generate_playable_units(scenario.unit_slots)
	scenario.playable_units = playable_units
	map.init_terrain(scenario)
	sim.init_world(scenario)
	trigger_engine.bind_scenario(scenario)
	sim.bind_radio(%RadioController, %OrdersParser)
	sim.init_resolution(scenario.briefing.frag_objectives)
	wordlist.bind_recognizer(STTService.get_recognizer())
```
