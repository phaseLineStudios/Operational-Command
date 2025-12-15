# SimWorld::set_rng_seed Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 582–586)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func set_rng_seed(new_rng_seed: int) -> void
```

- **new_rng_seed**: Seed value.

## Description

Set RNG seed (determinism).

## Source

```gdscript
func set_rng_seed(new_rng_seed: int) -> void:
	rng_seed = new_rng_seed
	_rng.seed = new_rng_seed
```
