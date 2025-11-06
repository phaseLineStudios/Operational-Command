# HQTable::_init_tts_system Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 112–156)</br>
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
	# Register the audio player with TTSService
	if TTSService and tts_player:
		TTSService.register_player(tts_player)
		LogService.trace("TTS player registered in HQTable.", "HQTable.gd:_init_tts_system")

	# Initialize UnitVoiceResponses with unit index, SimWorld, and terrain renderer
	if unit_voices and sim and map:
		unit_voices.init(sim._units_by_id, sim, map.renderer)
		LogService.trace("Unit voice responses initialized.", "HQTable.gd:_init_tts_system")

	# Initialize UnitAutoResponses for automatic unit event reporting
	if unit_auto_voices and sim and map:
		unit_auto_voices.init(
			sim, sim._units_by_id, map.renderer, counter_controller, sim.artillery_controller
		)
		LogService.trace("Unit auto responses initialized.", "HQTable.gd:_init_tts_system")

		# Wire up ammo/fuel warnings to auto-response system
		_wire_logistics_warnings()

	# Wire up OrdersRouter to UnitVoiceResponses
	var orders_router := get_node_or_null("%RadioController/OrdersRouter")
	if orders_router and unit_voices:
		# Check if already connected to avoid duplicate connections
		if not orders_router.order_applied.is_connected(unit_voices._on_order_applied):
			orders_router.order_applied.connect(unit_voices._on_order_applied)
			LogService.trace(
				"Unit voice responses connected to OrdersRouter.", "HQTable.gd:_init_tts_system"
			)
		else:
			LogService.warning(
				"OrdersRouter already connected to UnitVoiceResponses!",
				"HQTable.gd:_init_tts_system"
			)

	# Wire up SimWorld radio_message signal to TTS for trigger API radio() calls
	if sim and TTSService:
		if not sim.radio_message.is_connected(_on_radio_message):
			sim.radio_message.connect(_on_radio_message)
			LogService.trace(
				"SimWorld radio_message connected to TTS.", "HQTable.gd:_init_tts_system"
			)
```
