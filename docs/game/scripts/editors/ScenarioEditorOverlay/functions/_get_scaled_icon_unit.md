# ScenarioEditorOverlay::_get_scaled_icon_unit Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 642–661)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D
```

## Description

Get (and cache) a scaled unit icon respecting affiliation

## Source

```gdscript
func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D:
	var base: Texture2D = null
	if u and u.unit:
		if ScenarioUnit.Affiliation.FRIEND == u.affiliation:
			base = u.unit.icon if u.unit.icon else null
		else:
			base = u.unit.enemy_icon if u.unit.enemy_icon else null
	if base == null:
		base = load(
			(
				"res://assets/textures/units/nato_unknown_platoon.png"
				if ScenarioUnit.Affiliation.FRIEND == u.affiliation
				else "res://assets/textures/units/enemy_unknown_platoon.png"
			)
		)
	var id_str := u.unit.id if u and u.unit and u.unit.id else "unknown"
	var key := "UNIT:%s:%d:%d" % [id_str, unit_icon_px, u.affiliation]
	return _scaled_cached(key, base, unit_icon_px)
```
