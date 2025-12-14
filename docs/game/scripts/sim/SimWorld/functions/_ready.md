# SimWorld::_ready Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 78–115)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initializes tick timing/RNG and wires router signals. Starts processing.

## Source

```gdscript
func _ready() -> void:
	_tick_dt = 1.0 / max(tick_hz, 0.001)
	if rng_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = rng_seed

	_router.order_applied.connect(_on_order_applied)
	_router.order_failed.connect(_on_order_failed)

	# Note: Ammo/fuel warnings are handled by UnitAutoResponses via HQTable signal connections.
	# SimWorld no longer emits radio_message for these to avoid duplicate transmissions.

	if engineer_controller:
		engineer_controller.task_confirmed.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal(
					"radio_message", "info", "%s: roger, %s task acknowledged." % [callsign, task]
				)
		)
		engineer_controller.task_started.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal("radio_message", "info", "%s: starting %s work." % [callsign, task])
		)
		engineer_controller.task_completed.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal("radio_message", "info", "%s: %s task complete." % [callsign, task])
		)

	set_process(true)
```
