# HQTable::_find_all_pickup_items Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 310–318)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _find_all_pickup_items(node: Node) -> Array[PickupItem]
```

## Description

Recursively find all PickupItem nodes in the tree

## Source

```gdscript
func _find_all_pickup_items(node: Node) -> Array[PickupItem]:
	var items: Array[PickupItem] = []
	if node is PickupItem:
		items.append(node)
	for child in node.get_children():
		items.append_array(_find_all_pickup_items(child))
	return items
```
