# RadioSubtitles::_deduplicate Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 388–397)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _deduplicate(arr: Array[String]) -> Array[String]
```

## Description

Deduplicate array

## Source

```gdscript
func _deduplicate(arr: Array[String]) -> Array[String]:
	var seen := {}
	var out: Array[String] = []
	for item in arr:
		if not seen.has(item):
			seen[item] = true
			out.append(item)
	return out
```
