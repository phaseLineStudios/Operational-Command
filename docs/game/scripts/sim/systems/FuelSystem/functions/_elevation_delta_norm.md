# FuelSystem::_elevation_delta_norm Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 294–315)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _elevation_delta_norm(a: Vector2, b: Vector2) -> float
```

## Source

```gdscript
func _elevation_delta_norm(a: Vector2, b: Vector2) -> float:
	## Approximate normalized elevation delta between two points using the elevation Image.
	var img: Image = terrain_data.elevation
	if img == null or img.is_empty():
		return 0.0

	var w_m: float = max(1.0, float(terrain_data.width_m))
	var h_m: float = max(1.0, float(terrain_data.height_m))
	var px_w: float = float(img.get_width())
	var px_h: float = float(img.get_height())

	# Convert meters to pixel indices, explicitly typed.
	var ax: int = clamp(int(round(a.x / w_m * px_w)), 0, int(px_w) - 1)
	var ay: int = clamp(int(round(a.y / h_m * px_h)), 0, int(px_h) - 1)
	var bx: int = clamp(int(round(b.x / w_m * px_w)), 0, int(px_w) - 1)
	var by: int = clamp(int(round(b.y / h_m * px_h)), 0, int(px_h) - 1)

	var ca: float = img.get_pixel(ax, ay).r
	var cb: float = img.get_pixel(bx, by).r
	return abs(cb - ca)
```
