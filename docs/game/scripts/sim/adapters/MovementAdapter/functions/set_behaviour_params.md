# MovementAdapter::set_behaviour_params Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 351–355)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func set_behaviour_params(speed_mult: float, _cover_bias_unused: float, noise_level: float) -> void
```

## Description

Behaviour mapping from AIAgent

## Source

```gdscript
func set_behaviour_params(speed_mult: float, _cover_bias_unused: float, noise_level: float) -> void:
	_speed_mult = speed_mult
	_noise_level = noise_level
```
