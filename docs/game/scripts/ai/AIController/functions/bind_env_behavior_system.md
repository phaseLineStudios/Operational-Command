# AIController::bind_env_behavior_system Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 505–534)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func bind_env_behavior_system(_env_sys: Node) -> void
```

## Description

Bind environment behaviour system signals (placeholder).

## Source

```gdscript
func bind_env_behavior_system(_env_sys: Node) -> void:
	if _env_sys == null:
		return
	if not _env_sys.is_connected("unit_lost", Callable(self, "_on_unit_lost")):
		_env_sys.unit_lost.connect(_on_unit_lost)
	if not _env_sys.is_connected("unit_recovered", Callable(self, "_on_unit_recovered")):
		_env_sys.unit_recovered.connect(_on_unit_recovered)
	if not _env_sys.is_connected("unit_bogged", Callable(self, "_on_unit_bogged")):
		_env_sys.unit_bogged.connect(_on_unit_bogged)
	if not _env_sys.is_connected("unit_unbogged", Callable(self, "_on_unit_unbogged")):
		_env_sys.unit_unbogged.connect(_on_unit_unbogged)
	_env_behavior_system = _env_sys
	# Relay env signals to orders router for radio/log feedback if available
	if _orders_router and _orders_router.has_signal("radio_message"):
		if not _env_sys.is_connected("unit_lost", Callable(_orders_router, "_on_unit_lost")):
			_env_sys.unit_lost.connect(func(uid): _emit_radio("info", "%s lost orientation" % uid))
		if not _env_sys.is_connected(
			"unit_recovered", Callable(_orders_router, "_on_unit_recovered")
		):
			_env_sys.unit_recovered.connect(
				func(uid): _emit_radio("info", "%s regained orientation" % uid)
			)
		if not _env_sys.is_connected("unit_bogged", Callable(_orders_router, "_on_unit_bogged")):
			_env_sys.unit_bogged.connect(func(uid): _emit_radio("warn", "%s bogged down" % uid))
		if not _env_sys.is_connected(
			"unit_unbogged", Callable(_orders_router, "_on_unit_unbogged")
		):
			_env_sys.unit_unbogged.connect(func(uid): _emit_radio("info", "%s moving again" % uid))
```
