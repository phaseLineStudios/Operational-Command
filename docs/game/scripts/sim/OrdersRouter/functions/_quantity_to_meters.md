# OrdersRouter::_quantity_to_meters Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 553–567)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _quantity_to_meters(qty: int, zone: String) -> float
```

- **qty**: Quantity value.
- **zone**: Unit label (e.g. "m", "km", "grid").
- **Return Value**: Distance in meters.

## Description

Convert a quantity and zone to meters.

## Source

```gdscript
func _quantity_to_meters(qty: int, zone: String) -> float:
	var z := zone.to_lower()
	match z:
		"m", "meter", "meters":
			return float(qty)
		"km", "kilometer", "kilometers":
			return float(qty) * 1000.0
		"grid", "tile", "cell", "square":
			if terrain_renderer and terrain_renderer.has_method("cell_size_m"):
				return float(qty) * float(terrain_renderer.cell_size_m())
			return float(qty) * 50.0
		_:
			return float(qty)
```
