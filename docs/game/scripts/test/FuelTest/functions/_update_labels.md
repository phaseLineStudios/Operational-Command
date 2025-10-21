# FuelTest::_update_labels Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 240–274)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _update_labels() -> void
```

## Source

```gdscript
func _update_labels() -> void:
	if lbl_rx:
		var rdbg: Dictionary = fuel.fuel_debug(rx.id)
		var rx_pct: String = (
			"n/a" if rdbg.get("percent", null) == null else str(int(rdbg["percent"]))
		)
		var rx_mult: float = float(rdbg.get("mult", 1.0))
		var rx_pen: int = int(rdbg.get("penalty_pct", 0))
		var rx_state_tag: String = String(rdbg.get("state", "n/a"))
		lbl_rx.text = (
			"Receiver  %s%% %s  x%.2f (-%d%%)  pos=(%.1f, %.1f)"
			% [rx_pct, rx_state_tag, rx_mult, rx_pen, rx.position_m.x, rx.position_m.y]
		)

	if lbl_tk:
		var stock: int = 0
		if tk.unit.throughput is Dictionary and tk.unit.throughput.has("fuel"):
			stock = int(tk.unit.throughput["fuel"])
		lbl_tk.text = (
			"Tanker    stock=%d   rate=%.1f/s   radius=%.1fm   d=%.1fm"
			% [stock, TK_RATE, TK_RADIUS, rx.position_m.distance_to(tk.position_m)]
		)

	if lbl_spd:
		var now_s: float = _now_s()
		var dt: float = max(1e-6, now_s - _last_time_s)
		_last_time_s = now_s
		var dist: float = rx.position_m.distance_to(_prev_pos_rx)
		_prev_pos_rx = rx.position_m
		var inst: float = dist / dt
		_ema_speed_rx = lerp(_ema_speed_rx, inst, 0.4)
		var rx_mult2: float = fuel.speed_mult(rx.id)
		lbl_spd.text = "Speed  atk=%.2fm/s (EMA)  mult=%.2f" % [_ema_speed_rx, rx_mult2]
```
