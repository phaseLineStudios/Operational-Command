# AIController::_ensure_adapter_cache Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 417–440)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _ensure_adapter_cache() -> void
```

## Source

```gdscript
func _ensure_adapter_cache() -> void:
	if _movement_adapter == null:
		_movement_adapter = movement_adapter_ref
	if _movement_adapter == null and not movement_adapter_path.is_empty():
		_movement_adapter = _get_node_from_path(movement_adapter_path) as MovementAdapter
	if _combat_adapter == null:
		_combat_adapter = combat_adapter_ref
	if _combat_adapter == null and not combat_adapter_path.is_empty():
		_combat_adapter = _get_node_from_path(combat_adapter_path) as CombatAdapter
	if _los_adapter == null:
		_los_adapter = los_adapter_ref
	if _los_adapter == null and not los_adapter_path.is_empty():
		_los_adapter = _get_node_from_path(los_adapter_path) as LOSAdapter
	if _orders_router == null:
		_orders_router = orders_router_ref
	if _orders_router == null and not orders_router_path.is_empty():
		_orders_router = _get_node_from_path(orders_router_path) as OrdersRouter
	if _agents_root == null:
		_agents_root = agents_root_ref
	if _agents_root == null:
		var node := _get_node_from_path(agents_root_path)
		_agents_root = node if node else self
```
