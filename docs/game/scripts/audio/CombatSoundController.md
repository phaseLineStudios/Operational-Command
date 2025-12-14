# CombatSoundController Class Reference

*File:* `scripts/audio/CombatSoundController.gd`
*Class name:* `CombatSoundController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name CombatSoundController
extends Node
```

## Brief

Manages combat and artillery sound effects.

## Detailed Description

Plays randomized artillery outgoing/impact sounds and distant combat audio.
Integrates with ArtilleryController and SimWorld signals.
Uses polyphonic audio to allow multiple overlapping sounds.

Maximum simultaneous artillery sounds per type

Called when artillery fires rounds.

Called when artillery rounds impact.

## Public Member Functions

- [`func _ready() -> void`](CombatSoundController/functions/_ready.md) — Initialize random generator, polyphonic streams, and timer.
- [`func _init_polyphonic_player(player: AudioStreamPlayer, polyphony: int) -> void`](CombatSoundController/functions/_init_polyphonic_player.md) — Initialize a polyphonic audio stream player.
- [`func _on_combat_fade_timeout() -> void`](CombatSoundController/functions/_on_combat_fade_timeout.md) — Called when combat fade timer times out.
- [`func _start_combat_sound_loop() -> void`](CombatSoundController/functions/_start_combat_sound_loop.md) — Start playing looping combat sound.
- [`func _stop_combat_sound_loop() -> void`](CombatSoundController/functions/_stop_combat_sound_loop.md) — Stop playing combat sound loop.
- [`func _on_combat_sound_finished() -> void`](CombatSoundController/functions/_on_combat_sound_finished.md) — Called when combat sound finishes - restart with new random sound if still in combat.
- [`func bind_artillery_controller(artillery: ArtilleryController) -> void`](CombatSoundController/functions/bind_artillery_controller.md) — Wire up to artillery controller signals.
- [`func bind_sim_world(sim_world: SimWorld) -> void`](CombatSoundController/functions/bind_sim_world.md) — Wire up to SimWorld signals.
- [`func _on_engagement_reported(_attacker_id: String, _defender_id: String, _damage: float) -> void`](CombatSoundController/functions/_on_engagement_reported.md) — Called when units engage in combat.
- [`func _pick_random_stream(list: Array[AudioStream]) -> AudioStream`](CombatSoundController/functions/_pick_random_stream.md) — Returns a random AudioStream from list or null if empty.

## Public Attributes

- `bool enable_artillery_sounds` — Enable artillery sound effects
- `bool enable_combat_sounds` — Enable distant combat sound effects
- `float combat_fade_time` — Time after last engagement before stopping combat sounds (seconds)
- `Array[AudioStream] sound_artillery_outgoing` — Artillery outgoing sounds (played when rounds are fired)
- `Array[AudioStream] sound_artillery_impact` — Artillery impact sounds (played when rounds impact)
- `Array[AudioStream] sound_distant_combat` — Distant combat sounds (played when units engage)
- `bool _combat_sound_playing`
- `Timer _combat_fade_timer`
- `AudioStreamPlayer _sfx_artillery_outgoing`
- `AudioStreamPlayer _sfx_artillery_impact`
- `AudioStreamPlayer _sfx_combat`
- `AudioStreamPlaybackPolyphonic _playback_outgoing`
- `AudioStreamPlaybackPolyphonic _playback_impact`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize random generator, polyphonic streams, and timer.

### _init_polyphonic_player

```gdscript
func _init_polyphonic_player(player: AudioStreamPlayer, polyphony: int) -> void
```

Initialize a polyphonic audio stream player.

### _on_combat_fade_timeout

```gdscript
func _on_combat_fade_timeout() -> void
```

Called when combat fade timer times out.

### _start_combat_sound_loop

```gdscript
func _start_combat_sound_loop() -> void
```

Start playing looping combat sound.

### _stop_combat_sound_loop

```gdscript
func _stop_combat_sound_loop() -> void
```

Stop playing combat sound loop.

### _on_combat_sound_finished

```gdscript
func _on_combat_sound_finished() -> void
```

Called when combat sound finishes - restart with new random sound if still in combat.

### bind_artillery_controller

```gdscript
func bind_artillery_controller(artillery: ArtilleryController) -> void
```

Wire up to artillery controller signals.

### bind_sim_world

```gdscript
func bind_sim_world(sim_world: SimWorld) -> void
```

Wire up to SimWorld signals.

### _on_engagement_reported

```gdscript
func _on_engagement_reported(_attacker_id: String, _defender_id: String, _damage: float) -> void
```

Called when units engage in combat.

### _pick_random_stream

```gdscript
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream
```

Returns a random AudioStream from list or null if empty.

## Member Data Documentation

### enable_artillery_sounds

```gdscript
var enable_artillery_sounds: bool
```

Decorators: `@export`

Enable artillery sound effects

### enable_combat_sounds

```gdscript
var enable_combat_sounds: bool
```

Decorators: `@export`

Enable distant combat sound effects

### combat_fade_time

```gdscript
var combat_fade_time: float
```

Decorators: `@export_range(0.0, 30.0, 0.1)`

Time after last engagement before stopping combat sounds (seconds)

### sound_artillery_outgoing

```gdscript
var sound_artillery_outgoing: Array[AudioStream]
```

Decorators: `@export`

Artillery outgoing sounds (played when rounds are fired)

### sound_artillery_impact

```gdscript
var sound_artillery_impact: Array[AudioStream]
```

Decorators: `@export`

Artillery impact sounds (played when rounds impact)

### sound_distant_combat

```gdscript
var sound_distant_combat: Array[AudioStream]
```

Decorators: `@export`

Distant combat sounds (played when units engage)

### _combat_sound_playing

```gdscript
var _combat_sound_playing: bool
```

### _combat_fade_timer

```gdscript
var _combat_fade_timer: Timer
```

### _sfx_artillery_outgoing

```gdscript
var _sfx_artillery_outgoing: AudioStreamPlayer
```

### _sfx_artillery_impact

```gdscript
var _sfx_artillery_impact: AudioStreamPlayer
```

### _sfx_combat

```gdscript
var _sfx_combat: AudioStreamPlayer
```

### _playback_outgoing

```gdscript
var _playback_outgoing: AudioStreamPlaybackPolyphonic
```

### _playback_impact

```gdscript
var _playback_impact: AudioStreamPlaybackPolyphonic
```
