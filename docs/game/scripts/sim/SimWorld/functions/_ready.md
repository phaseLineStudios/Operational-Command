# SimWorld::_ready Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 58–70)</br>
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

	set_process(true)
```
