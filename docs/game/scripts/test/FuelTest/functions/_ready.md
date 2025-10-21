# FuelTest::_ready Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 36–104)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_wire_ui()  # resolve HUD nodes if present
	_ensure_panel_below_hud_block()  # <-- put refuel panel under the top HUD

	# FuelSystem
	fuel = FuelSystem.new()
	add_child(fuel)
	fuel.add_to_group("FuelSystem")

	# Receiver
	rx = ScenarioUnit.new()
	rx.id = "rx"
	rx.callsign = "Receiver"
	rx.position_m = Vector2(10, 10)
	rx.unit = UnitData.new()
	rx.unit.id = "rx_unit"
	rx.unit.speed_kph = RX_SPEED_KPH
	rx.unit.strength = 100
	rx.unit.morale = 1.0

	# Tanker / Logistics
	tk = ScenarioUnit.new()
	tk.id = "tk"
	tk.callsign = "Tanker"
	tk.position_m = Vector2(35, 10)
	tk.unit = UnitData.new()
	tk.unit.id = "tk_unit"
	tk.unit.speed_kph = 12.0
	tk.unit.strength = 100
	tk.unit.morale = 1.0
	tk.unit.throughput = {"fuel": TK_STOCK_START}
	tk.unit.supply_transfer_rate = TK_RATE
	tk.unit.supply_transfer_radius_m = TK_RADIUS
	tk.unit.equipment_tags = ["LOGISTICS", "FUEL_TANKER"]

	# Register in FuelSystem
	rx_state = UnitFuelState.new()
	rx_state.fuel_capacity = RX_CAP
	rx_state.state_fuel = RX_START
	fuel.register_scenario_unit(rx, rx_state)
	fuel.register_scenario_unit(tk, UnitFuelState.new())

	# Optional slowdown hook
	if "bind_fuel_system" in rx:
		rx.bind_fuel_system(fuel)
	if "bind_fuel_system" in tk:
		tk.bind_fuel_system(fuel)

	# Wire HUD buttons (guarded)
	if btn_move:
		btn_move.pressed.connect(_on_toggle_move)
	if btn_drain:
		btn_drain.pressed.connect(_on_drain)
	if btn_tp:
		btn_tp.pressed.connect(_on_tp)
	if btn_topup:
		btn_topup.pressed.connect(_on_topup)

	# Panel: always on (like ammo panel)
	if panel:
		panel.visible = true
		panel.open([rx, tk], fuel, depot_stock, "Refuel Units")
		panel.refuel_committed.connect(_on_panel_done, Object.CONNECT_ONE_SHOT)

	_last_time_s = _now_s()
	_prev_pos_rx = rx.position_m
	set_process(true)
```
