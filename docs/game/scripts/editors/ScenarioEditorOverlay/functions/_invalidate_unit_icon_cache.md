# ScenarioEditorOverlay::_invalidate_unit_icon_cache Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 724–734)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _invalidate_unit_icon_cache(u: UnitData) -> void
```

## Description

Remove all scaled entries for this unit (both affiliations/sizes).

## Source

```gdscript
func _invalidate_unit_icon_cache(u: UnitData) -> void:
	var id_str := String(u.id if u and u.id != "" else "unknown")
	var prefix := "UNIT:%s:" % id_str
	var to_erase: Array = []
	for k in _icon_cache.keys():
		if String(k).begins_with(prefix):
			to_erase.append(k)
	for k in to_erase:
		_icon_cache.erase(k)
```
