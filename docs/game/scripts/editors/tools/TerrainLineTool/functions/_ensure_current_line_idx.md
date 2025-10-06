# TerrainLineTool::_ensure_current_line_idx Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 404–418)</br>
*Belongs to:* [TerrainLineTool](../TerrainLineTool.md)

**Signature**

```gdscript
func _ensure_current_line_idx() -> int
```

## Description

Ensure _edit_idx points at the line with _edit_id, return index or -1

## Source

```gdscript
func _ensure_current_line_idx() -> int:
	if data == null or _edit_id < 0:
		return -1
	if _edit_idx >= 0 and _edit_idx < data.lines.size():
		var s: Dictionary = data.lines[_edit_idx]
		if typeof(s) == TYPE_DICTIONARY and s.get("id", null) == _edit_id:
			return _edit_idx
	for i in data.lines.size():
		var s2 = data.lines[i]
		if typeof(s2) == TYPE_DICTIONARY and s2.get("id", null) == _edit_id:
			_edit_idx = i
			return _edit_idx
	return -1
```
