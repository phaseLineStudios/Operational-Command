# UnitCounter::_ensure_mesh_materials Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 47–58)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _ensure_mesh_materials(color: Color, face: Texture2D) -> void
```

## Source

```gdscript
func _ensure_mesh_materials(color: Color, face: Texture2D) -> void:
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = color
	mesh.set_surface_override_material(0, body_mat)

	var face_mat: StandardMaterial3D = (
		load("res://assets/models/unit_counter/UnitCounterFace.material").duplicate()
	)
	face_mat.albedo_texture = face
	mesh.set_surface_override_material(1, face_mat)
```
