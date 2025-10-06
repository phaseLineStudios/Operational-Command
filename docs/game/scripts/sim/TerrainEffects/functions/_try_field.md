# TerrainEffects::_try_field Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 169–174)</br>
*Belongs to:* [TerrainEffects](../TerrainEffects.md)

**Signature**

```gdscript
func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float
```

## Source

```gdscript
static func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float:
	if src == null:
		return def
	return float(src.get(name))
```
