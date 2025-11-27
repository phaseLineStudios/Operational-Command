# ScenarioEditorOverlay::_get_scaled_icon_trigger Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 681–688)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _get_scaled_icon_trigger(trig: ScenarioTrigger) -> Texture2D
```

## Description

Get (and cache) the scaled trigger center icon

## Source

```gdscript
func _get_scaled_icon_trigger(trig: ScenarioTrigger) -> Texture2D:
	if trig.icon == null:
		return null
	var rpath := String(trig.icon.resource_path)
	var key := "TRIGGER:%s:%d" % [rpath, trigger_icon_px]
	return _scaled_cached(key, trig.icon, trigger_icon_px)
```
