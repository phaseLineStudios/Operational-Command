# SpeechWordlistUpdater::_collect_mission_callsigns Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 63–76)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _collect_mission_callsigns() -> Array[String]
```

## Description

Collects callsigns from both scenario units and playable units.
Returns a lowercase, de-duplicated list.
[return] Array[String] of callsigns.

## Source

```gdscript
func _collect_mission_callsigns() -> Array[String]:
	var out: Array[String] = []
	var scen := Game.current_scenario
	if scen == null:
		return out
	for su in scen.units:
		if su != null and su.callsign != "":
			out.append(su.callsign.to_lower())
	for su in scen.playable_units:
		if su != null and su.callsign != "":
			out.append(su.callsign.to_lower())
	return _dedup_preserve(out)
```
