# EnvSoundController::_setup_timers Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 71–87)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _setup_timers() -> void
```

## Description

Setup Timer nodes for ambient SFX and thunder instead of _process() updates.

## Source

```gdscript
func _setup_timers() -> void:
	# Create and configure ambient SFX timer
	_ambient_sfx_timer = Timer.new()
	_ambient_sfx_timer.one_shot = true
	_ambient_sfx_timer.timeout.connect(_on_ambient_sfx_timeout)
	add_child(_ambient_sfx_timer)

	# Create and configure thunder timer
	_thunder_timer = Timer.new()
	_thunder_timer.one_shot = true
	_thunder_timer.timeout.connect(_on_thunder_timeout)
	add_child(_thunder_timer)

	# Start initial timers
	_reset_timers()
```
