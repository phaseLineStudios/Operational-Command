# ContentDB::list_campaigns Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 130–154)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_campaigns() -> Array
```

## Description

List all campaigns

## Source

```gdscript
func list_campaigns() -> Array:
	var camps := get_all_objects("campaigns")
	if camps.is_empty():
		return []

	var decorated: Array = []
	var i := 0
	for c in camps:
		if c.is_empty():
			continue
		var order := int(c.get("order", 2147483647))  # missing => bottom
		decorated.append([order, i, c])
		i += 1

	decorated.sort_custom(func(a, b): return a[1] < b[1] if a[0] == b[0] else a[0] < b[0])

	var out: Array[CampaignData] = []
	for item in decorated:
		var d: Dictionary = item[2]
		var res := CampaignData.deserialize(d)
		if res != null:
			out.append(res)
	return out
```
