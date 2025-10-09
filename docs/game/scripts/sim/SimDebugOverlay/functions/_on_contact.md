# SimDebugOverlay::_on_contact Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 174–182)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_contact(attacker_id: String, defender_id: String) -> void
```

## Description

Mark attacker/defender as “hot” for a short period after combat.
[param attacker_id] Attacker unit id.
[param defender_id] Defender unit id.

## Source

```gdscript
func _on_contact(attacker_id: String, defender_id: String) -> void:
	if not show_combat_hot:
		return
	var now := _sim.get_mission_time_s() if _sim else Time.get_ticks_msec() / 1000.0
	_recent_contact_until[attacker_id] = now + 10.0
	_recent_contact_until[defender_id] = now + 10.0
	queue_redraw()
```
