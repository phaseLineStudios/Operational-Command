# FuelSystem::tick Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 126–131)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func tick(delta: float) -> void
```

## Source

```gdscript
func tick(delta: float) -> void:
	## Main simulation entry. Call from SimWorld each frame.
	_consume_tick(delta)
	_refuel_tick(delta)
```
