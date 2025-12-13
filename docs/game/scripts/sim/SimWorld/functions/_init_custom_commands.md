# SimWorld::_init_custom_commands Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 653–714)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _init_custom_commands(scenario: ScenarioData) -> void
```

- **scenario**: Scenario with units, terrain, and custom commands.

## Description

Initialize mission-specific voice grammar with STT and OrdersParser.
  
  

Collects and registers:
  
1. Custom commands from `member ScenarioData.custom_commands`
  
2. Unit callsigns from scenario units
  
3. Terrain labels from `member TerrainData.labels`
  
  

Updates:
  
- [OrdersParser] via `method OrdersParser.register_custom_command`
  
- [NARules] via `method NARules.set_mission_overrides`
  
- [STTService] via `method STTService.update_wordlist` with all collected words
  
  

**Called automatically by `method init_world` during mission initialization.**

## Source

```gdscript
func _init_custom_commands(scenario: ScenarioData) -> void:
	# Get parser reference (via router's export or find in tree)
	var parser: OrdersParser = null
	if _router.get_parent():
		for child in _router.get_parent().get_children():
			if child is OrdersParser:
				parser = child
				break

	# Collect custom command keywords and extra grammar
	var custom_actions: Dictionary = {}
	var extra_words: Array[String] = []

	for cmd in scenario.custom_commands:
		if cmd is CustomCommand and cmd.keyword != "":
			# Register with parser if available
			if parser:
				var metadata := {"trigger_id": cmd.trigger_id, "route_as_order": cmd.route_as_order}
				parser.register_custom_command(cmd.keyword, metadata)

			# Collect for NARules grammar
			extra_words.append(cmd.keyword)
			extra_words.append_array(cmd.additional_grammar)

			# If route_as_order, add to action_synonyms
			if cmd.route_as_order:
				custom_actions[cmd.keyword.to_lower()] = OrdersParser.OrderType.CUSTOM

	# Set mission overrides in NARules for STT grammar
	if not custom_actions.is_empty() or not extra_words.is_empty():
		NARules.set_mission_overrides(custom_actions, extra_words)

	# Collect unit callsigns
	var callsigns: Array[String] = []
	for su in scenario.units:
		if su != null and su.callsign != "":
			callsigns.append(su.callsign)
	for su in scenario.playable_units:
		if su != null and su.callsign != "":
			callsigns.append(su.callsign)

	# Collect terrain labels
	var labels: Array[String] = []
	if scenario.terrain and scenario.terrain.labels:
		for label in scenario.terrain.labels:
			var txt := str(label.get("text", "")).strip_edges()
			if txt != "":
				labels.append(txt)

	# Update STT recognizer with complete mission grammar
	# Includes: base grammar, custom commands, callsigns, and terrain labels
	STTService.update_wordlist(callsigns, labels)

	LogService.info(
		(
			"Updated STT grammar: %d custom commands, %d callsigns, %d labels"
			% [scenario.custom_commands.size(), callsigns.size(), labels.size()]
		),
		"SimWorld.gd"
	)
```

## References

- [`member ScenarioData.custom_commands`](../../../data/ScenarioData.md#custom_commands)
- [`member TerrainData.labels`](../../../data/TerrainData.md#labels)
- [`method OrdersParser.register_custom_command`](../../../radio/OrdersParser/functions/register_custom_command.md)
- [`method NARules.set_mission_overrides`](../../../radio/NARules.md#set_mission_overrides)
- [`method STTService.update_wordlist`](../../../radio/STTService/functions/update_wordlist.md)
- [`method init_world`](init_world.md)
