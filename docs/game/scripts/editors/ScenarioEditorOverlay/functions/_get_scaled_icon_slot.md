# ScenarioEditorOverlay::_get_scaled_icon_slot Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 589–593)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _get_scaled_icon_slot() -> Texture2D
```

## Description

Get (and cache) the scaled slot icon

## Source

```gdscript
func _get_scaled_icon_slot() -> Texture2D:
	var key := "SLOT:%d" % slot_icon_px
	return _scaled_cached(key, slot_icon, slot_icon_px)
```
