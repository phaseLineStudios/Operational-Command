extends Node
class_name RadioFeedback
## Catches when an invalid command is emitted from parsed order and plays an audio to inform the player

## Ammo: RadioFeedback
## Subscribes to AmmoSystem and order-parse events and surfaces them to the player.
## In this basic implementation, messages are logged via `LogService` and an error
## If present in a scene, call `bind_ammo(...)` or let `_ready()` auto-bind by group lookup.

## UI audio for parse errors (must exist in the scene tree at %ErrorSound).
@onready var error_player: AudioStreamPlayer2D = %ErrorSound

## Ready-time setup:
## - Connect to `OrdersParser.parse_error`
## - Try to locate an AmmoSystem (by group "AmmoSystem") and bind to its signals.
func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parseError)
	
	var ammo := get_tree().get_first_node_in_group("AmmoSystem") as AmmoSystem
	if ammo:
		bind_ammo(ammo)

## Bind to an AmmoSystem instance to receive ammo/resupply events.
## Safe to call multiple times; connects the five signals used below.
func bind_ammo(ammo: AmmoSystem) -> void:
	ammo.ammo_low.connect(_on_ammo_low)
	ammo.ammo_critical.connect(_on_ammo_critical)
	ammo.ammo_empty.connect(_on_ammo_empty)
	ammo.resupply_started.connect(_on_resupply_started)
	ammo.resupply_completed.connect(_on_resupply_completed)

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

## Order parser signaled an error (e.g., invalid command). Play a short error sound.
func _on_parseError(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback.gd:11")
	if error_player:
		error_player.play()
