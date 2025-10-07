class_name RadioFeedback
extends Node
## Catches when an invalid command is emitted from parsed order and plays
## an audio to inform the player

## Ammo: RadioFeedback
## Subscribes to AmmoSystem and order-parse events and surfaces them to the player.
## In this basic implementation, messages are logged via `LogService` and an error
## If present in a scene, call `bind_ammo(...)` or let `_ready()` auto-bind by group lookup.

## Fuel: RadioFeedback
## Subscribes to FuelSystem and order-parse events and surfaces them to the player.
## In this basic implementation, messages are logged via `LogService` and an error sound is played.
## If present in a scene, call `bind_fuel(...)` or let `_ready()` auto-bind by group lookup.

## UI audio for parse errors (must exist in the scene tree at %ErrorSound).
@onready var error_player: AudioStreamPlayer2D = %ErrorSound


## Ready-time setup:
## - Connect to `OrdersParser.parse_error`
## - Try to locate `AmmoSystem` and `FuelSystem` instances in the scene by group lookup.
func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parse_error)

	var ammo := get_tree().get_first_node_in_group("AmmoSystem") as AmmoSystem
	if ammo:
		bind_ammo(ammo)

	var fuel := get_tree().get_first_node_in_group("FuelSystem") as FuelSystem
	if fuel:
		bind_fuel(fuel)


## Bind to an AmmoSystem instance to receive ammo/resupply events.
## Safe to call multiple times; connects all relevant signals.
func bind_ammo(ammo: AmmoSystem) -> void:
	if ammo == null:
		return
	ammo.ammo_low.connect(_on_ammo_low)
	ammo.ammo_critical.connect(_on_ammo_critical)
	ammo.ammo_empty.connect(_on_ammo_empty)
	ammo.resupply_started.connect(_on_resupply_started)
	ammo.resupply_completed.connect(_on_resupply_completed)


## Bind to a FuelSystem instance to receive fuel/refuel events.
## Safe to call multiple times; connects all relevant signals.
func bind_fuel(fuel: FuelSystem) -> void:
	if fuel == null:
		return
	fuel.fuel_low.connect(_on_fuel_low)
	fuel.fuel_critical.connect(_on_fuel_critical)
	fuel.fuel_empty.connect(_on_fuel_empty)
	fuel.refuel_started.connect(_on_fuel_refuel_started)
	fuel.refuel_completed.connect(_on_fuel_refuel_completed)
	fuel.unit_immobilized_fuel_out.connect(_on_unit_immobilized_fuel_out)
	fuel.unit_mobilized_after_refuel.connect(_on_unit_mobilized_after_refuel)


# AMMO SYSTEM RADIO FEEDBACK


## “Bingo ammo” — remaining ammo <= low threshold but > 0.
func _on_ammo_low(uid: String) -> void:
	LogService.info("%s: Bingo ammo" % uid, "Radio")


## “Ammo critical” — remaining ammo <= critical threshold but > 0.
func _on_ammo_critical(uid: String) -> void:
	LogService.info("%s: Ammo critical" % uid, "Radio")


## “Winchester” — out of ammo.
func _on_ammo_empty(uid: String) -> void:
	LogService.info("%s: Winchester" % uid, "Radio")


## Logistics unit began resupplying a recipient.
func _on_resupply_started(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Resupplying" % [src, dst], "Radio")


## Resupply finished because the recipient is full or the source ran out of stock.
func _on_resupply_completed(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Resupply complete" % [src, dst], "Radio")


# FUEL SYSTEM RADIO FEEDBACK


## “Low fuel” — remaining fuel <= low threshold but > critical.
func _on_fuel_low(uid: String) -> void:
	LogService.info("%s: Low fuel" % uid, "Radio")


## “Fuel state red” — remaining fuel <= critical threshold but > 0.
func _on_fuel_critical(uid: String) -> void:
	LogService.info("%s: Fuel state red" % uid, "Radio")


## “Winchester fuel” — completely out of fuel.
func _on_fuel_empty(uid: String) -> void:
	LogService.info("%s: Winchester fuel" % uid, "Radio")


## Refuel operation started between two units.
func _on_fuel_refuel_started(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Refueling" % [src, dst], "Radio")


## Refuel operation completed successfully.
func _on_fuel_refuel_completed(src: String, dst: String) -> void:
	LogService.info("%s -> %s: Refuel complete" % [src, dst], "Radio")


## A unit became immobilized due to fuel depletion.
func _on_unit_immobilized_fuel_out(uid: String) -> void:
	LogService.info("%s: Immobilized, out of fuel" % uid, "Radio")


## A unit regained mobility after being refueled.
func _on_unit_mobilized_after_refuel(uid: String) -> void:
	LogService.info("%s: Mobility restored after refuel" % uid, "Radio")


## Order parser signaled an error (e.g., invalid command). Plays a short error sound.
func _on_parse_error(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback")
	if error_player:
		error_player.play()
