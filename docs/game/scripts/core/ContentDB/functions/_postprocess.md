# ContentDB::_postprocess Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 23–48)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func _postprocess(v: Variant) -> Variant
```

## Description

Recursively convert special string literals to engine types (minimal).

## Source

```gdscript
func _postprocess(v: Variant) -> Variant:
	match typeof(v):
		TYPE_DICTIONARY:
			var d := v as Dictionary
			for k in d.keys():
				d[k] = _postprocess(d[k])
			return d
		TYPE_ARRAY:
			var a := v as Array
			for i in a.size():
				a[i] = _postprocess(a[i])
			return a
		TYPE_STRING:
			var s := String(v).strip_edges()
			if s.begins_with("Vector2(") and s.ends_with(")"):
				var inner := s.substr(8, s.length() - 9)
				var parts := inner.split(",", false)
				if parts.size() == 2:
					var x := parts[0].strip_edges().to_float()
					var y := parts[1].strip_edges().to_float()
					return Vector2(x, y)
			return v
		_:
			return v
```
