# TerrainData::_emit_coalesced Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 114–132)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _emit_coalesced(pend: Array, sig: Signal) -> void
```

## Source

```gdscript
func _emit_coalesced(pend: Array, sig: Signal) -> void:
	if pend.is_empty():
		return
	var by_kind := {}
	for e in pend:
		var k: String = e[0]
		var ids: PackedInt32Array = e[1]
		if not by_kind.has(k):
			by_kind[k] = ids.duplicate()
		else:
			var dst: PackedInt32Array = by_kind[k]
			for i in ids:
				if not dst.has(i):
					dst.append(i)
	pend.clear()
	for k in by_kind.keys():
		emit_signal(sig.get_name(), k, by_kind[k])
```
