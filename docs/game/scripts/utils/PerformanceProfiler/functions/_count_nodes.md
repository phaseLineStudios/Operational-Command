# PerformanceProfiler::_count_nodes Function Reference

*Defined at:* `scripts/utils/PerformanceProfiler.gd` (lines 53–59)</br>
*Belongs to:* [PerformanceProfiler](../../PerformanceProfiler.md)

**Signature**

```gdscript
func _count_nodes(node: Node) -> int
```

## Source

```gdscript
func _count_nodes(node: Node) -> int:
	var count := 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count
```
