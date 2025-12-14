class_name CombatSoundController
extends Node
## Manages combat and artillery sound effects.
##
## Plays randomized artillery outgoing/impact sounds and distant combat audio.
## Integrates with ArtilleryController and SimWorld signals.
## Uses polyphonic audio to allow multiple overlapping sounds.

## Maximum simultaneous artillery sounds per type
const ARTILLERY_POLYPHONY := 16

@export_category("Settings")
## Enable artillery sound effects
@export var enable_artillery_sounds: bool = true
## Enable distant combat sound effects
@export var enable_combat_sounds: bool = true
## Time after last engagement before stopping combat sounds (seconds)
@export_range(0.0, 30.0, 0.1) var combat_fade_time: float = 5.0

@export_category("Artillery Sounds")
## Artillery outgoing sounds (played when rounds are fired)
@export var sound_artillery_outgoing: Array[AudioStream]
## Artillery impact sounds (played when rounds impact)
@export var sound_artillery_impact: Array[AudioStream]

@export_category("Combat Sounds")
## Distant combat sounds (played when units engage)
@export var sound_distant_combat: Array[AudioStream]

var _rng := RandomNumberGenerator.new()
var _combat_sound_playing: bool = false
var _combat_fade_timer: Timer

var _sfx_artillery_outgoing: AudioStreamPlayer
var _sfx_artillery_impact: AudioStreamPlayer
var _sfx_combat: AudioStreamPlayer
var _playback_outgoing: AudioStreamPlaybackPolyphonic
var _playback_impact: AudioStreamPlaybackPolyphonic


## Initialize random generator, polyphonic streams, and timer.
func _ready() -> void:
	_rng.randomize()

	_sfx_artillery_outgoing = $SfxArtilleryOutgoing
	_sfx_artillery_impact = $SfxArtilleryImpact
	_sfx_combat = $SfxCombat

	_init_polyphonic_player(_sfx_artillery_outgoing, ARTILLERY_POLYPHONY)
	_init_polyphonic_player(_sfx_artillery_impact, ARTILLERY_POLYPHONY)

	_playback_outgoing = _sfx_artillery_outgoing.get_stream_playback()
	_playback_impact = _sfx_artillery_impact.get_stream_playback()

	_sfx_combat.finished.connect(_on_combat_sound_finished)

	# Setup timer for combat fade instead of _process()
	_combat_fade_timer = Timer.new()
	_combat_fade_timer.one_shot = true
	_combat_fade_timer.timeout.connect(_on_combat_fade_timeout)
	add_child(_combat_fade_timer)


## Initialize a polyphonic audio stream player.
func _init_polyphonic_player(player: AudioStreamPlayer, polyphony: int) -> void:
	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = polyphony
	player.stream = stream
	player.play()


## Called when combat fade timer times out.
func _on_combat_fade_timeout() -> void:
	if _combat_sound_playing:
		_stop_combat_sound_loop()


## Start playing looping combat sound.
func _start_combat_sound_loop() -> void:
	var sfx := _pick_random_stream(sound_distant_combat)
	if sfx:
		_sfx_combat.stream = sfx
		_sfx_combat.play()
		_combat_sound_playing = true
		LogService.debug("Started distant combat sound loop", "CombatSoundController")


## Stop playing combat sound loop.
func _stop_combat_sound_loop() -> void:
	if _sfx_combat.playing:
		_sfx_combat.stop()
	_combat_sound_playing = false
	LogService.debug("Stopped distant combat sound loop", "CombatSoundController")


## Called when combat sound finishes - restart with new random sound if still in combat.
func _on_combat_sound_finished() -> void:
	if _combat_sound_playing:
		var sfx := _pick_random_stream(sound_distant_combat)
		if sfx:
			_sfx_combat.stream = sfx
			_sfx_combat.play()


## Wire up to artillery controller signals.
func bind_artillery_controller(artillery: ArtilleryController) -> void:
	if not artillery:
		return

	artillery.rounds_shot.connect(_on_artillery_shot)
	artillery.rounds_impact.connect(_on_artillery_impact)

	LogService.debug("CombatSoundController bound to ArtilleryController", "CombatSoundController")


## Wire up to SimWorld signals.
func bind_sim_world(sim_world: SimWorld) -> void:
	if not sim_world:
		return

	sim_world.engagement_reported.connect(_on_engagement_reported)

	LogService.debug("CombatSoundController bound to SimWorld", "CombatSoundController")


## Called when artillery fires rounds.
func _on_artillery_shot(
	_unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int
) -> void:
	if not enable_artillery_sounds:
		return

	if not _playback_outgoing:
		push_warning("CombatSoundController: Outgoing playback not initialized")
		return

	var sfx := _pick_random_stream(sound_artillery_outgoing)
	if sfx:
		_playback_outgoing.play_stream(sfx, 0.0, 0.0, 1.0)
		LogService.debug("Playing artillery outgoing sound", "CombatSoundController")


## Called when artillery rounds impact.
func _on_artillery_impact(
	_unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int, _damage: float
) -> void:
	if not enable_artillery_sounds:
		return

	if not _playback_impact:
		push_warning("CombatSoundController: Impact playback not initialized")
		return

	var sfx := _pick_random_stream(sound_artillery_impact)
	if sfx:
		_playback_impact.play_stream(sfx, 0.0, 0.0, 1.0)
		LogService.debug("Playing artillery impact sound", "CombatSoundController")


## Called when units engage in combat.
func _on_engagement_reported(_attacker_id: String, _defender_id: String, _damage: float) -> void:
	if not enable_combat_sounds:
		return

	# Start combat sound if not already playing
	if not _combat_sound_playing:
		_start_combat_sound_loop()

	# Restart fade timer - combat continues
	if _combat_fade_timer:
		_combat_fade_timer.start(combat_fade_time)


## Returns a random AudioStream from list or null if empty.
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream:
	if list.is_empty():
		return null
	if list.size() == 1:
		return list[0]
	var index := _rng.randi_range(0, list.size() - 1)
	return list[index]
