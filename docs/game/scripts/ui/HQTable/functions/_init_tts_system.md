# HQTable::_init_tts_system Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 194–220)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_tts_system() -> void
```

## Description

Initialize TTS service and wire up unit voice responses

## Source

```gdscript
func _init_tts_system() -> void:
	if TTSService and tts_player:
		if TTSService.is_initializing():
			await TTSService.stream_ready
		TTSService.register_player(tts_player)

	if unit_voices and sim and map:
		unit_voices.init(
			sim._units_by_id, sim, map.renderer, counter_controller, sim.artillery_controller
		)
		_wire_logistics_warnings()

	var orders_router := get_node_or_null("%RadioController/OrdersRouter")
	if orders_router and unit_voices:
		if not orders_router.order_applied.is_connected(unit_voices._on_order_applied):
			orders_router.order_applied.connect(unit_voices._on_order_applied)
		else:
			LogService.warning(
				"OrdersRouter already connected to UnitVoiceResponses!",
				"HQTable.gd:_init_tts_system"
			)

	if sim and TTSService:
		if not sim.radio_message.is_connected(_on_radio_message):
			sim.radio_message.connect(_on_radio_message)
```
