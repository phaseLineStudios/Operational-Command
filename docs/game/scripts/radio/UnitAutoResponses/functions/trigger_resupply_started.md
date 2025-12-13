# UnitAutoResponses::trigger_resupply_started Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 567–585)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_resupply_started(src_unit_id: String, dst_unit_id: String) -> void
```

- **src_unit_id**: Supplier unit ID.
- **dst_unit_id**: Recipient unit ID.

## Description

Trigger resupply started event.

## Source

```gdscript
func trigger_resupply_started(src_unit_id: String, dst_unit_id: String) -> void:
	var dst_callsign: String = _id_to_callsign.get(dst_unit_id, dst_unit_id)
	var src_unit = _units_by_id.get(src_unit_id)
	if not src_unit or not src_unit.playable:
		return

	# Cooldown check (30 seconds, matching JSON config)
	var cooldown_key := "resupply_started:%s" % src_unit_id
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _resupply_refuel_last_triggered.get(cooldown_key, 0.0)
	if current_time - last_trigger_time < 30.0:
		return

	var src_callsign: String = _id_to_callsign.get(src_unit_id, src_unit_id)
	var message := "Resupplying %s." % dst_callsign
	_queue_custom_message(src_unit_id, src_callsign, message, Priority.NORMAL)
	_resupply_refuel_last_triggered[cooldown_key] = current_time
```
