# FuelTest::_wire_ui Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 118–151)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _wire_ui() -> void
```

## Source

```gdscript
func _wire_ui() -> void:
	# Try both hierarchies: with "Pad" and without.
	btn_move = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnMove", "CanvasLayer/HUD/Panel/VBox/Row1/BtnMove"]
	)
	btn_drain = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnDrain", "CanvasLayer/HUD/Panel/VBox/Row1/BtnDrain"]
	)
	btn_tp = _find_button(
		[
			"CanvasLayer/HUD/Panel/Pad/VBox/Row1/BtnTeleport",
			"CanvasLayer/HUD/Panel/VBox/Row1/BtnTeleport"
		]
	)
	btn_topup = _find_button(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row2/BtnTopUp", "CanvasLayer/HUD/Panel/VBox/Row2/BtnTopUp"]
	)
	lbl_rx = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblRx", "CanvasLayer/HUD/Panel/VBox/Row3/LblRx"]
	)
	lbl_tk = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row3/LblTk", "CanvasLayer/HUD/Panel/VBox/Row3/LblTk"]
	)
	lbl_spd = _find_label(
		["CanvasLayer/HUD/Panel/Pad/VBox/Row4/LblSpd", "CanvasLayer/HUD/Panel/VBox/Row4/LblSpd"]
	)
	# panel is resolved/created below

	if lbl_rx:
		lbl_rx.autowrap_mode = TextServer.AUTOWRAP_WORD
	if lbl_tk:
		lbl_tk.autowrap_mode = TextServer.AUTOWRAP_WORD
```
