# AudioManager Class Reference

*File:* `scripts/core/AudioManager.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Persistent audio manager for UI sounds and music.

## Detailed Description

This autoload persists across scene changes, ensuring sounds aren't cut off
when transitioning between scenes.

Number of polyphonic voices for UI sounds

Default fade duration in seconds

Play a randomized UI sound effect from array.
`sound` The AudioStream array of sounds to choose from
`volume_db_range` Volume adjustment range (1.0 = ± 1db)
`pitch_scale_range` Pitch multiplier range (0.1 = ± 10%)

Play a music track with fade in.
`music_stream` The AudioStream to play
`fade_in_duration` Duration of fade in effect in seconds
`loop` Whether the music should loop

Crossfade from current music to a new track.
`music_stream` The new AudioStream to crossfade to
`crossfade_duration` Duration of crossfade effect in seconds
`loop` Whether the new music should loop

Internal helper to fade a music player's volume

## Public Member Functions

- [`func _ready() -> void`](AudioManager/functions/_ready.md)
- [`func _init_ui_player() -> void`](AudioManager/functions/_init_ui_player.md) — Initialize the UI sound player with polyphonic stream
- [`func play_ui_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void`](AudioManager/functions/play_ui_sound.md) — Play a UI sound effect.
- [`func _init_music_players() -> void`](AudioManager/functions/_init_music_players.md) — Initialize the music players for crossfading
- [`func stop_music(fade_out_duration: float = DEFAULT_FADE_DURATION) -> void`](AudioManager/functions/stop_music.md) — Stop the currently playing music with fade out.
- [`func is_music_playing() -> bool`](AudioManager/functions/is_music_playing.md) — Check if music is currently playing
- [`func get_current_music() -> AudioStream`](AudioManager/functions/get_current_music.md) — Get the currently playing music stream

## Public Attributes

- `AudioStream main_menu_music`
- `AudioStreamPlayer _ui_player`
- `AudioStreamPlaybackPolyphonic _ui_playback`
- `AudioStreamPlayer _music_player_a`
- `AudioStreamPlayer _music_player_b`
- `AudioStreamPlayer _current_music_player`
- `Tween _music_tween`
- `AudioStream _current_music_stream`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _init_ui_player

```gdscript
func _init_ui_player() -> void
```

Initialize the UI sound player with polyphonic stream

### play_ui_sound

```gdscript
func play_ui_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void
```

Play a UI sound effect.
`sound` The AudioStream to play
`volume_db` Volume adjustment in decibels (0 = default, negative = quieter)
`pitch_scale` Pitch multiplier (1.0 = normal, >1.0 = higher, <1.0 = lower)

### _init_music_players

```gdscript
func _init_music_players() -> void
```

Initialize the music players for crossfading

### stop_music

```gdscript
func stop_music(fade_out_duration: float = DEFAULT_FADE_DURATION) -> void
```

Stop the currently playing music with fade out.
`fade_out_duration` Duration of fade out effect in seconds

### is_music_playing

```gdscript
func is_music_playing() -> bool
```

Check if music is currently playing

### get_current_music

```gdscript
func get_current_music() -> AudioStream
```

Get the currently playing music stream

## Member Data Documentation

### main_menu_music

```gdscript
var main_menu_music: AudioStream
```

### _ui_player

```gdscript
var _ui_player: AudioStreamPlayer
```

### _ui_playback

```gdscript
var _ui_playback: AudioStreamPlaybackPolyphonic
```

### _music_player_a

```gdscript
var _music_player_a: AudioStreamPlayer
```

### _music_player_b

```gdscript
var _music_player_b: AudioStreamPlayer
```

### _current_music_player

```gdscript
var _current_music_player: AudioStreamPlayer
```

### _music_tween

```gdscript
var _music_tween: Tween
```

### _current_music_stream

```gdscript
var _current_music_stream: AudioStream
```
