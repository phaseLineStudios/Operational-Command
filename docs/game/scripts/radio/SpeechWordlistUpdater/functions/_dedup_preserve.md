# SpeechWordlistUpdater::_dedup_preserve Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 96–103)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _dedup_preserve(arr: Array[String]) -> Array[String]
```

## Description

De-duplicates an array while preserving order.
[param arr] Input list.
[return] New list with unique items, first occurrence kept.

## Source

```gdscript
func _dedup_preserve(arr: Array[String]) -> Array[String]:
	var seen := {}
	var out: Array[String] = []
	for s in arr:
		if not seen.has(s):
			seen[s] = true
			out.append(s)
	return out
```
