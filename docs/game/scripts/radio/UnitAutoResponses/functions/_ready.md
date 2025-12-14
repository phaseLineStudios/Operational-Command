# UnitAutoResponses::_ready Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 109–119)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_rng.randomize()
	_load_auto_responses()

	_queue_timer = Timer.new()
	_queue_timer.one_shot = false
	_queue_timer.wait_time = global_cooldown_s
	_queue_timer.timeout.connect(_on_queue_timer_timeout)
	add_child(_queue_timer)
```
