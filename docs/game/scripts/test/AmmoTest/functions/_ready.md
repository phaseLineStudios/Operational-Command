# AmmoTest::_ready Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 45–99)</br>
*Belongs to:* [AmmoTest](../AmmoTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Runtime-only nodes so nothing leaks into main scenes
	ammo = AmmoSystem.new()
	add_child(ammo)
	ammo.add_to_group("AmmoSystem")

	profile = preload("res://data/ammo/default_caps.tres")
	ammo.ammo_profile = profile

	adapter = CombatAdapter.new()
	adapter.ammo_system_path = ammo.get_path()  # set BEFORE add_child so _ready() binds
	add_child(adapter)
	adapter.fire_blocked_empty.connect(
		func(uid: String, t: String) -> void: _print("[BLOCK] %s cannot fire (%s empty)" % [uid, t])
	)

	# Radio-style logs
	ammo.ammo_low.connect(func(uid: String) -> void: _print("[RADIO] %s: Bingo ammo" % uid))
	ammo.ammo_critical.connect(func(uid: String) -> void: _print("[RADIO] %s: Ammo critical" % uid))
	ammo.ammo_empty.connect(func(uid: String) -> void: _print("[RADIO] %s: Winchester" % uid))
	ammo.resupply_started.connect(
		func(src: String, dst: String) -> void: _print("[RADIO] %s -> %s: Resupplying" % [src, dst])
	)
	ammo.resupply_completed.connect(
		func(src: String, dst: String) -> void:
			_print("[RADIO] %s -> %s: Resupply complete" % [src, dst])
	)

	# Make the log visible & auto-scrolling
	_enable_log()

	_spawn_units()
	_wire_ui()

	_embed_rearm_panel()

	_update_hud()
	_update_link_status()

	# optional 1s console/HUD tick (helps verify resupply over time)
	_print_tick = Timer.new()
	_print_tick.wait_time = 1.0
	_print_tick.one_shot = false
	add_child(_print_tick)
	_print_tick.timeout.connect(
		func() -> void:
			var cur := int(shooter.state_ammunition.get(AMMO_TYPE, 0))
			var cap := int(shooter.ammunition.get(AMMO_TYPE, 0))
			var stock := int(logi.throughput.get(AMMO_TYPE, 0))
			print("[TICK] shooter %d/%d  stock %d" % [cur, cap, stock])
			_update_hud()
	)
	_print_tick.start()
```
