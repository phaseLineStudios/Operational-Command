# ScenarioEditorOverlay::_scale_icon Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 616–619)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D
```

## Description

Utility used by task glyphs to request scaled textures

## Source

```gdscript
func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D:
	return _scaled_cached(key, tex, px)
```
