# DebugOverlay::_icon_for_unit Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 146–158)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func _icon_for_unit(su: ScenarioUnit) -> Texture2D
```

## Source

```gdscript
func _icon_for_unit(su: ScenarioUnit) -> Texture2D:
	if su == null or su.unit == null:
		return null
	var aff: ScenarioUnit.Affiliation = (
		su.affiliation if "affiliation" in su else ScenarioUnit.Affiliation.FRIEND
	)
	return (
		su.unit.icon
		if int(aff) == int(ScenarioUnit.Affiliation.FRIEND)
		else (su.unit.enemy_icon if su.unit.enemy_icon != null else su.unit.icon)
	)
```
