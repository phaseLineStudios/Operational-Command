# Debrief::set_mission_name Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 109–113)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_mission_name(mission_name: String) -> void
```

## Description

Sets the mission name and refreshes the title label.

## Source

```gdscript
func set_mission_name(mission_name: String) -> void:
	_mission_name = mission_name
	_update_title()
```
