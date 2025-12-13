# UnitMgmt::_status_string Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 153–174)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _status_string(uid: String) -> String
```

## Description

Derive a status string for external consumers.

## Source

```gdscript
func _status_string(uid: String) -> String:
	var cur_strength: float = _unit_strength.get(uid, 0.0)
	if cur_strength <= 0.0:
		return "WIPED_OUT"

	var u := _find_unit(uid)
	if u == null:
		return "UNKNOWN"

	var cap: float = float(max(1, u.strength))
	var pct: float = clamp(cur_strength / cap, 0.0, 1.0)
	var thr: float = (
		u.understrength_threshold
		if u.understrength_threshold > 0.0
		else _panel.understrength_threshold
	)

	if pct < thr:
		return "UNDERSTRENGTH"
	return "ACTIVE"
```
