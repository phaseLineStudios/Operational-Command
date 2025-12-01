extends Node
## Persistent audio manager for UI sounds and music.
##
## This autoload persists across scene changes, ensuring sounds aren't cut off
## when transitioning between scenes.

## Number of polyphonic voices for UI sounds
const UI_POLYPHONY := 32

var _ui_player: AudioStreamPlayer
var _ui_playback: AudioStreamPlaybackPolyphonic


func _ready() -> void:
	_init_ui_player()


## Initialize the UI sound player with polyphonic stream
func _init_ui_player() -> void:
	_ui_player = AudioStreamPlayer.new()
	add_child(_ui_player)

	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = UI_POLYPHONY
	_ui_player.stream = stream
	_ui_player.bus = "UI"  # Uses UI audio bus (falls back to Master if not defined)
	_ui_player.play()
	_ui_playback = _ui_player.get_stream_playback()


## Play a UI sound effect.
## [param sound] The AudioStream to play
## [param volume_db] Volume adjustment in decibels (0 = default, negative = quieter)
## [param pitch_scale] Pitch multiplier (1.0 = normal, >1.0 = higher, <1.0 = lower)
func play_ui_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not sound:
		return
	if not _ui_playback:
		push_warning("AudioManager: UI playback not initialized")
		return

	_ui_playback.play_stream(sound, 0.0, volume_db, pitch_scale)


## Play a randomized UI sound effect from array.
## [param sound] The AudioStream array of sounds to choose from
## [param volume_db_range] Volume adjustment range (1.0 = ± 1db)
## [param pitch_scale_range] Pitch multiplier range (0.1 = ± 10%)
func play_random_ui_sound(
	sounds: Array[AudioStream],
	volume_db_rand: Vector2 = Vector2(1.0, 1.0),
	pitch_scale_rand: Vector2 = Vector2(1.0, 1.0)
) -> void:
	var sound := sounds[randi() % sounds.size()]
	var volume_db := randf_range(volume_db_rand.x, volume_db_rand.y)
	var pitch_scale := randf_range(pitch_scale_rand.x, pitch_scale_rand.y)
	play_ui_sound(sound, volume_db, pitch_scale)
