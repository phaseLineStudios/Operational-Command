# CombatSoundController::_ready Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 42–63)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize random generator, polyphonic streams, and timer.

## Source

```gdscript
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
```
