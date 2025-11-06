# ScenarioEditorOverlay::_get_tex Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 738–748)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _get_tex(path: String) -> Texture2D
```

- **path**: res:// path.
- **Return Value**: Texture2D or null.

## Description

Load or fetch cached texture.

## Source

```gdscript
func _get_tex(path: String) -> Texture2D:
	if path == "":
		return null
	if _tex_cache.has(path) and is_instance_valid(_tex_cache[path]):
		return _tex_cache[path]
	var t: Texture2D = load(path)
	if t:
		_tex_cache[path] = t
	return t
```
