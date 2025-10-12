# SimDebugOverlay::_process Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 104–117)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

- **_dt**: Delta time (seconds).

## Description

Fade recent-combat markers and request redraws while enabled.

## Source

```gdscript
func _process(_dt: float) -> void:
	if show_combat_hot and _sim:
		var now := _sim.get_mission_time_s()
		var changed := false
		for uid in _recent_contact_until.keys():
			if now >= float(_recent_contact_until[uid]):
				_recent_contact_until.erase(uid)
				changed = true
		if changed:
			queue_redraw()

	queue_redraw()
```
