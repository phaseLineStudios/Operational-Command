# AIController::create_agent Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 384–410)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func create_agent(unit_id: int) -> AIAgent
```

## Description

Instantiate and bind an AIAgent using configured adapters.

## Source

```gdscript
func create_agent(unit_id: int) -> AIAgent:
	_ensure_adapter_cache()
	if _movement_adapter == null:
		LogService.error(
			"AIController missing MovementAdapter reference.", "AIController.gd:create_agent"
		)
		return null
	if _combat_adapter == null:
		LogService.error(
			"AIController missing CombatAdapter reference.", "AIController.gd:create_agent"
		)
		return null
	if _los_adapter == null:
		LogService.warning(
			"AIController missing LOSAdapter; TaskWait until_contact will be blind.",
			"AIController.gd:create_agent"
		)
	var agent := AIAgent.new()
	agent.unit_id = unit_id
	agent.bind_adapters(_movement_adapter, _combat_adapter, _los_adapter, _orders_router)
	if _agents_root and is_instance_valid(_agents_root):
		_agents_root.add_child(agent)
	else:
		add_child(agent)
	return agent
```
