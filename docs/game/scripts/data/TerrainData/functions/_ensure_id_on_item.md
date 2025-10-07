# TerrainData::_ensure_id_on_item Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 455–461)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _ensure_id_on_item(item: Dictionary, counter_prop: String) -> int
```

## Description

Ensure item has ID

## Source

```gdscript
func _ensure_id_on_item(item: Dictionary, counter_prop: String) -> int:
	if not item.has("id") or int(item.id) <= 0:
		item.id = self.get(counter_prop)
		self.set(counter_prop, int(self.get(counter_prop)) + 1)
	return int(item.id)
```
