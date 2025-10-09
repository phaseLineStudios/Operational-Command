# SimWorld::set_rng_seed Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 279–283)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func set_rng_seed(new_rng_seed: int) -> void
```

## Description

Set RNG seed (determinism).
[param new_rng_seed] Seed value.

## Source

```gdscript
func set_rng_seed(new_rng_seed: int) -> void:
	rng_seed = new_rng_seed
	_rng.seed = new_rng_seed
```
