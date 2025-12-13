# PickupItem::_barycentric_coords Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 416–435)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _barycentric_coords(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3
```

## Description

Calculate barycentric coordinates of point p in triangle (a, b, c)

## Source

```gdscript
func _barycentric_coords(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3:
	var v0 := b - a
	var v1 := c - a
	var v2 := p - a

	var d00 := v0.dot(v0)
	var d01 := v0.dot(v1)
	var d11 := v1.dot(v1)
	var d20 := v2.dot(v0)
	var d21 := v2.dot(v1)

	var denom := d00 * d11 - d01 * d01
	if abs(denom) < 0.0001:
		return Vector3(1, 0, 0)

	var v := (d11 * d20 - d01 * d21) / denom
	var w := (d00 * d21 - d01 * d20) / denom
	var u := 1.0 - v - w

	return Vector3(u, v, w)
```
