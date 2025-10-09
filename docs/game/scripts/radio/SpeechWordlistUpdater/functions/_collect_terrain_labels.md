# SpeechWordlistUpdater::_collect_terrain_labels Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 80–92)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _collect_terrain_labels() -> Array[String]
```

## Description

Extracts map label texts from `member TerrainRender.data.labels`.
Returns a de-duplicated list (original casing).
[return] Array[String] of label texts.

## Source

```gdscript
func _collect_terrain_labels() -> Array[String]:
	var out: Array[String] = []
	var data := terrain_renderer.data
	if data == null:
		return out
	var labels := data.labels
	for label in labels:
		var txt := str(label.get("text", "")).strip_edges()
		if txt != "":
			out.append(txt)
	return _dedup_preserve(out)
```

## References

- [`member TerrainRender.data.labels`](../../../terrain/TerrainRender.md#datalabels)
