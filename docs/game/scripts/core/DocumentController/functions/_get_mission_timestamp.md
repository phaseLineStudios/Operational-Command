# DocumentController::_get_mission_timestamp Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 416–423)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _get_mission_timestamp() -> String
```

## Description

Get current mission timestamp as formatted string

## Source

```gdscript
func _get_mission_timestamp() -> String:
	# TODO: Get actual mission time from SimWorld
	var time := Time.get_ticks_msec() / 1000.0
	var minutes := int(time / 60)
	var seconds := int(time) % 60
	return "%02d:%02d" % [minutes, seconds]
```
