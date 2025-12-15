# TreeSpawner::_setup_noise Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 167–173)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _setup_noise() -> void
```

## Source

```gdscript
func _setup_noise() -> void:
	_noise = FastNoiseLite.new()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency = 0.05
	_noise.seed = random_seed if random_seed != 0 else randi()
```
