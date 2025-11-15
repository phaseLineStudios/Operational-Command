# ScenarioEditorOverlay::_scaled_cached Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 695–709)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D
```

## Description

Scale and cache a texture by key and target pixel size

## Source

```gdscript
func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D:
	var cached: Texture2D = _icon_cache.get(key)
	if cached:
		return cached
	if base == null:
		return null
	var img := base.get_image()
	if img.is_empty():
		return base
	img.resize(px, px, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	_icon_cache[key] = tex
	return tex
```
