# UnitMgmt::_status_string Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 148–164)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _status_string(u: UnitData) -> String
```

## Description

Derive a status string for external consumers.

## Source

```gdscript
func _status_string(u: UnitData) -> String:
	if u.state_strength <= 0.0:
		return "WIPED_OUT"

	var cap: float = float(max(1, u.strength))
	var pct: float = clamp(u.state_strength / cap, 0.0, 1.0)
	var thr: float = (
		u.understrength_threshold
		if u.understrength_threshold > 0.0
		else _panel.understrength_threshold
	)

	if pct < thr:
		return "UNDERSTRENGTH"
	return "ACTIVE"
```
