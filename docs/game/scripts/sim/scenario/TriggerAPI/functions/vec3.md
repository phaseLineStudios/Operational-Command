# TriggerAPI::vec3 Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 633–636)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func vec3(x: float, y: float, z: float) -> Vector3
```

- **x**: X coordinate
- **y**: Y coordinate
- **z**: Z coordinate
- **Return Value**: Vector3 with given coordinates

## Description

Create a Vector3 from x, y, and z coordinates.
  
  

**Usage in trigger expressions:**

```
# Create 3D position
set_global("spawn_point", vec3(500, 0, 750))
```

## Source

```gdscript
func vec3(x: float, y: float, z: float) -> Vector3:
	return Vector3(x, y, z)
```
