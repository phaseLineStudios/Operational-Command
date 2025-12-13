# PickupItem::_get_document_uv_from_hit Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 346–414)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _get_document_uv_from_hit(hit: Dictionary) -> Vector2
```

## Description

Get UV coordinates from raycast hit on document mesh

## Source

```gdscript
func _get_document_uv_from_hit(hit: Dictionary) -> Vector2:
	if not hit.has("face_index"):
		return Vector2(-1, -1)

	var mesh_node := get_node_or_null("Mesh")
	if not mesh_node:
		return Vector2(-1, -1)

	var mesh_instance: MeshInstance3D = null
	for child in mesh_node.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break

	if not mesh_instance:
		return Vector2(-1, -1)

	var mesh := mesh_instance.mesh
	if not mesh is ArrayMesh:
		return Vector2(-1, -1)

	if mesh.get_surface_count() <= PAPER_SURFACE_INDEX:
		return Vector2(-1, -1)

	var arrays := mesh.surface_get_arrays(PAPER_SURFACE_INDEX)
	if arrays.size() == 0:
		return Vector2(-1, -1)

	var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var uvs: PackedVector2Array = arrays[Mesh.ARRAY_TEX_UV]
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]

	if vertices.size() == 0 or uvs.size() == 0:
		return Vector2(-1, -1)

	var face_index: int = hit.face_index
	var i0: int
	var i1: int
	var i2: int

	if indices.size() > 0:
		if face_index * 3 + 2 >= indices.size():
			return Vector2(-1, -1)
		i0 = indices[face_index * 3]
		i1 = indices[face_index * 3 + 1]
		i2 = indices[face_index * 3 + 2]
	else:
		i0 = face_index * 3
		i1 = face_index * 3 + 1
		i2 = face_index * 3 + 2

	if i0 >= vertices.size() or i1 >= vertices.size() or i2 >= vertices.size():
		return Vector2(-1, -1)

	var v0 := mesh_instance.to_global(vertices[i0])
	var v1 := mesh_instance.to_global(vertices[i1])
	var v2 := mesh_instance.to_global(vertices[i2])

	var hit_pos: Vector3 = hit.position
	var bary := _barycentric_coords(hit_pos, v0, v1, v2)

	var uv0 := uvs[i0]
	var uv1 := uvs[i1]
	var uv2 := uvs[i2]

	var uv := uv0 * bary.x + uv1 * bary.y + uv2 * bary.z
	return uv
```
