# PerformanceProfiler::_count_meshes Function Reference

*Defined at:* `scripts/utils/PerformanceProfiler.gd` (lines 60–69)</br>
*Belongs to:* [PerformanceProfiler](../../PerformanceProfiler.md)

**Signature**

```gdscript
func _count_meshes(node: Node) -> int
```

## Source

```gdscript
func _count_meshes(node: Node) -> int:
	var count := 0
	if node is MeshInstance3D:
		count = 1
		var mesh := (node as MeshInstance3D).mesh
		if mesh:
			print("  Mesh: %s - %d surfaces" % [node.name, mesh.get_surface_count()])
	for child in node.get_children():
		count += _count_meshes(child)
	return count
```
