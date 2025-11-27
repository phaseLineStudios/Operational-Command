# AIAgent::_ensure_adapter_refs Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 54–64)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func _ensure_adapter_refs() -> void
```

## Source

```gdscript
func _ensure_adapter_refs() -> void:
	if _router == null and not orders_router_path.is_empty():
		_router = get_node_or_null(orders_router_path)
	if _movement == null and not movement_adapter_path.is_empty():
		_movement = get_node_or_null(movement_adapter_path)
	if _combat == null and not combat_adapter_path.is_empty():
		_combat = get_node_or_null(combat_adapter_path)
	if _los == null and not los_adapter_path.is_empty():
		_los = get_node_or_null(los_adapter_path)
```
