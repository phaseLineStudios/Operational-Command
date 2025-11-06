class_name CustomCommand
extends Resource
## Custom voice command definition for per-mission special commands.
##
## Allows scenarios to define mission-specific voice commands that can:
## [br]1. Trigger a specific ScenarioTrigger when heard via [member trigger_id]
## [br]2. Generate a CUSTOM order type that OrdersRouter handles via [member route_as_order]
## [br]3. Both (trigger fires AND order routes)
## [br]
## [b]Usage:[/b] Add to [member ScenarioData.custom_commands] array in scenario JSON.
## The system automatically registers keywords with OrdersParser and adds grammar to STT.
## [br]
## [b]Example JSON:[/b]
## [codeblock]
## {
##   "keyword": "fire mission",
##   "additional_grammar": ["danger", "close", "grid"],
##   "trigger_id": "fire_mission_trigger",
##   "route_as_order": true
## }
## [/codeblock]

## Primary keyword or phrase that activates this command (e.g., "fire mission").
## Matching is case-insensitive and uses substring matching in OrdersParser.
@export var keyword: String = ""
## Additional grammar words to add to STT recognition for better accuracy.
## Include related terms that might be said with this command.
@export var additional_grammar: Array[String] = []
## Optional trigger ID to auto-activate when this command is heard.
## If set, the trigger with this ID will have its condition forced true.
@export var trigger_id: String = ""
## If true, generates a CUSTOM order type that routes through OrdersRouter.
## Listen to [signal OrdersRouter.custom_order_received] to handle the order.
@export var route_as_order: bool = false


## Serialize to dictionary for JSON persistence.
func serialize() -> Dictionary:
	return {
		"keyword": keyword,
		"additional_grammar": additional_grammar.duplicate(),
		"trigger_id": trigger_id,
		"route_as_order": route_as_order
	}


## Deserialize from dictionary.
static func deserialize(d: Variant) -> CustomCommand:
	if typeof(d) != TYPE_DICTIONARY:
		return null
	var cmd := CustomCommand.new()
	cmd.keyword = str(d.get("keyword", ""))
	var grammar = d.get("additional_grammar", [])
	if typeof(grammar) == TYPE_ARRAY:
		var arr: Array[String] = []
		for w in grammar:
			arr.append(str(w))
		cmd.additional_grammar = arr
	cmd.trigger_id = str(d.get("trigger_id", ""))
	cmd.route_as_order = bool(d.get("route_as_order", false))
	return cmd
