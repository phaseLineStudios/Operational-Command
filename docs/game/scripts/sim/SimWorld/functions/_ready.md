# SimWorld::_ready Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 67–101)</br>
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

	if ammo_system:
		ammo_system.ammo_low.connect(
			func(uid): emit_signal("radio_message", "warn", "%s low ammo." % uid)
		)
		ammo_system.ammo_critical.connect(
			func(uid): emit_signal("radio_message", "warn", "%s critical ammo." % uid)
		)
		ammo_system.ammo_empty.connect(
			func(uid): emit_signal("radio_message", "error", "%s winchester (out of ammo)." % uid)
		)

	if fuel_system:
		fuel_system.fuel_low.connect(
			func(uid): emit_signal("radio_message", "warn", "%s fuel low." % uid)
		)
		fuel_system.fuel_critical.connect(
			func(uid): emit_signal("radio_message", "warn", "%s fuel critical." % uid)
		)
		fuel_system.fuel_empty.connect(
			func(uid): emit_signal("radio_message", "error", "%s immobilized: fuel out." % uid)
		)

	set_process(true)
```
