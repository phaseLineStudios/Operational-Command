# UnitStrengthBadge::set_unit Function Reference

*Defined at:* `scripts/ui/widgets/UnitStrengthBadge.gd` (lines 34–51)</br>
*Belongs to:* [UnitStrengthBadge](../../UnitStrengthBadge.md)

**Signature**

```gdscript
func set_unit(u: UnitData, current_strength: float, threshold: float = -1.0) -> void
```

- **u**: UnitData template (for max strength).
- **current_strength**: Current strength value (from campaign or mission state).
- **threshold**: Optional understrength threshold override.

## Description

Update the badge from a UnitData and current strength. Creates UI if called before _ready().

## Source

```gdscript
func set_unit(u: UnitData, current_strength: float, threshold: float = -1.0) -> void:
	_ensure_ui()
	if threshold > 0.0:
		understrength_threshold = threshold

	var cap: float = float(max(1, u.strength))
	var cur: float = float(max(0.0, current_strength))
	var pct: float = 0.0 if cur <= 0.0 else clamp(cur / cap, 0.0, 1.0)

	_percent_lbl.text = str(int(round(pct * 100.0))) + "%"

	# Status color: wiped out at exactly zero strength
	if cur <= 0.0:
		_status_rect.color = Color(0.8, 0.2, 0.2)
	elif pct < understrength_threshold:
		_status_rect.color = Color(0.95, 0.7, 0.1)
	else:
		_status_rect.color = Color(0.2, 0.8, 0.2)
```
