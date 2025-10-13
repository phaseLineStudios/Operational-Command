# ContentDB::get_briefings Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 253–261)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_briefings(ids: Array) -> Array[BriefData]
```

## Description

Get multiple briefings by ids

## Source

```gdscript
func get_briefings(ids: Array) -> Array[BriefData]:
	var out: Array[BriefData] = []
	for raw in ids:
		var u: BriefData = get_briefing(String(raw))
		if u != null:
			out.append(u)
	return out
```
