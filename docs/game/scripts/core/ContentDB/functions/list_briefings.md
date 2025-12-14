# ContentDB::list_briefings Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 302–314)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_briefings() -> Array[BriefData]
```

## Description

List all briefings

## Source

```gdscript
func list_briefings() -> Array[BriefData]:
	var camps := get_all_objects("briefs")
	if camps.is_empty():
		return []

	var out: Array[BriefData] = []
	for item in camps:
		var res := BriefData.deserialize(item)
		if res != null:
			out.append(res)
	return out
```
