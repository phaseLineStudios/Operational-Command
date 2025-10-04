extends Node
class_name RadioFeedback
## Catches when an invalid command is emitted from parsed order and plays an audio to inform the player

@onready var error_player: AudioStreamPlayer2D = %ErrorSound

func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parseError)
	
	var ammo := get_tree().get_first_node_in_group("AmmoSystem") as AmmoSystem
	if ammo:
		bind_ammo(ammo)

func bind_ammo(ammo: AmmoSystem) -> void:
	ammo.ammo_low.connect(_on_ammo_low)
	ammo.ammo_critical.connect(_on_ammo_critical)
	ammo.ammo_empty.connect(_on_ammo_empty)
	ammo.resupply_started.connect(_on_resupply_started)
	ammo.resupply_completed.connect(_on_resupply_completed)

# Not sure how this should be implemented, so I stay with this
func _on_ammo_low(uid: String) -> void:       LogService.info("%s: Bingo ammo" % uid, "Radio")
func _on_ammo_critical(uid: String) -> void:  LogService.info("%s: Ammo critical" % uid, "Radio")
func _on_ammo_empty(uid: String) -> void:     LogService.info("%s: Winchester" % uid, "Radio")
func _on_resupply_started(src, dst):          LogService.info("%s -> %s: Resupplying" % [src, dst], "Radio")
func _on_resupply_completed(src, dst):        LogService.info("%s -> %s: Resupply complete" % [src, dst], "Radio")


func _on_parseError(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback.gd:11")
	if error_player:
		error_player.play()
