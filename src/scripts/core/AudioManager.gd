extends Node
## Persistent audio manager for UI sounds and music.
##
## This autoload persists across scene changes, ensuring sounds aren't cut off
## when transitioning between scenes.

## Number of polyphonic voices for UI sounds
const UI_POLYPHONY := 32

## Default fade duration in seconds
const DEFAULT_FADE_DURATION := 1.0

@export var main_menu_music: AudioStream = preload("res://audio/music/mus_main_menu_loop.wav")

var _ui_player: AudioStreamPlayer
var _ui_playback: AudioStreamPlaybackPolyphonic
var _music_player_a: AudioStreamPlayer
var _music_player_b: AudioStreamPlayer
var _current_music_player: AudioStreamPlayer
var _music_tween: Tween
var _current_music_stream: AudioStream


func _ready() -> void:
	_init_ui_player()
	_init_music_players()


## Initialize the UI sound player with polyphonic stream
func _init_ui_player() -> void:
	_ui_player = AudioStreamPlayer.new()
	add_child(_ui_player)

	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = UI_POLYPHONY
	_ui_player.stream = stream
	_ui_player.bus = "UI"
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


## Initialize the music players for crossfading
func _init_music_players() -> void:
	_music_player_a = AudioStreamPlayer.new()
	_music_player_a.name = "MusicPlayerA"
	_music_player_a.bus = "Music"
	_music_player_a.volume_db = -80.0
	add_child(_music_player_a)

	_music_player_b = AudioStreamPlayer.new()
	_music_player_b.name = "MusicPlayerB"
	_music_player_b.bus = "Music"
	_music_player_b.volume_db = -80.0
	add_child(_music_player_b)

	_current_music_player = _music_player_a


## Play a music track with fade in.
## [param music_stream] The AudioStream to play
## [param fade_in_duration] Duration of fade in effect in seconds
## [param loop] Whether the music should loop
func play_music(
	music_stream: AudioStream, fade_in_duration: float = DEFAULT_FADE_DURATION, loop: bool = true
) -> void:
	if not music_stream:
		push_warning("AudioManager: No music stream provided to play_music")
		return

	# Stop any existing music first
	if is_music_playing():
		stop_music(0.0)  # Immediate stop, we'll fade in the new track

	# Set up the current player
	_current_music_player.stream = music_stream
	_current_music_stream = music_stream

	# Enable looping if requested
	if music_stream is AudioStreamWAV:
		music_stream.loop_mode = (
			AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
		)
	elif music_stream is AudioStreamOggVorbis:
		music_stream.loop = loop

	# Start playing
	_current_music_player.play()

	# Fade in
	_fade_music_player(_current_music_player, -80.0, 0.0, fade_in_duration)


## Stop the currently playing music with fade out.
## [param fade_out_duration] Duration of fade out effect in seconds
func stop_music(fade_out_duration: float = DEFAULT_FADE_DURATION) -> void:
	if not is_music_playing():
		return

	if fade_out_duration <= 0.0:
		# Immediate stop
		_current_music_player.stop()
		_current_music_player.volume_db = -80.0
		_current_music_stream = null
	else:
		# Fade out then stop
		_fade_music_player(
			_current_music_player, _current_music_player.volume_db, -80.0, fade_out_duration
		)
		# Stop playback after fade completes
		await get_tree().create_timer(fade_out_duration).timeout
		if _current_music_player:
			_current_music_player.stop()
			_current_music_stream = null


## Crossfade from current music to a new track.
## [param music_stream] The new AudioStream to crossfade to
## [param crossfade_duration] Duration of crossfade effect in seconds
## [param loop] Whether the new music should loop
func crossfade_to(
	music_stream: AudioStream, crossfade_duration: float = DEFAULT_FADE_DURATION, loop: bool = true
) -> void:
	if not music_stream:
		push_warning("AudioManager: No music stream provided to crossfade_to")
		return

	# If nothing is playing, just play the new track
	if not is_music_playing():
		play_music(music_stream, crossfade_duration, loop)
		return

	# If same track is already playing, do nothing
	if _current_music_stream == music_stream:
		return

	# Determine which player to use for the new track
	var old_player := _current_music_player
	var new_player := (
		_music_player_b if _current_music_player == _music_player_a else _music_player_a
	)

	# Set up the new player
	new_player.stream = music_stream
	_current_music_stream = music_stream

	# Enable looping if requested
	if music_stream is AudioStreamWAV:
		music_stream.loop_mode = (
			AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
		)
	elif music_stream is AudioStreamOggVorbis:
		music_stream.loop = loop

	# Start the new player silent
	new_player.volume_db = -80.0
	new_player.play()

	# Switch current player reference
	_current_music_player = new_player

	# Crossfade: fade out old, fade in new
	_fade_music_player(old_player, old_player.volume_db, -80.0, crossfade_duration)
	_fade_music_player(new_player, -80.0, 0.0, crossfade_duration)

	# Stop the old player after crossfade completes
	await get_tree().create_timer(crossfade_duration).timeout
	if old_player:
		old_player.stop()


## Check if music is currently playing
func is_music_playing() -> bool:
	return _current_music_player != null and _current_music_player.playing


## Get the currently playing music stream
func get_current_music() -> AudioStream:
	return _current_music_stream


## Internal helper to fade a music player's volume
func _fade_music_player(
	player: AudioStreamPlayer, from_db: float, to_db: float, duration: float
) -> void:
	if not player:
		return

	# Kill existing tween if any
	if _music_tween and _music_tween.is_running():
		_music_tween.kill()

	# Create new tween
	_music_tween = create_tween()
	_music_tween.set_ease(Tween.EASE_IN_OUT)
	_music_tween.set_trans(Tween.TRANS_CUBIC)

	# Fade the volume
	player.volume_db = from_db
	_music_tween.tween_property(player, "volume_db", to_db, duration)
