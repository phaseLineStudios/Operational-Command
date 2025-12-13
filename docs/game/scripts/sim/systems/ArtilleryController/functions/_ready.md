# ArtilleryController::_ready Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 94–98)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_rng.randomize()
	add_to_group("ArtilleryController")
```
