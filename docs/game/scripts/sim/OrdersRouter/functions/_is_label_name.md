# OrdersRouter::_is_label_name Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 374–386)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _is_label_name(l_name: String) -> bool
```

- **l_name**: Candidate label text.
- **Return Value**: `true` if a matching label exists.

## Description

Test whether a string matches a TerrainData label (tolerant).

## Source

```gdscript
func _is_label_name(l_name: String) -> bool:
	if terrain_renderer == null or terrain_renderer.data == null:
		return false
	var key := _norm_label(l_name)
	for label in terrain_renderer.data.labels:
		var txt := str(label.get("text", "")).strip_edges()
		if txt == "":
			continue
		if _norm_label(txt) == key:
			return true
	return false
```
