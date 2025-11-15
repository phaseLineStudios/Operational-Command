# LogService::_get_fmt_time Function Reference

*Defined at:* `scripts/core/LogService.gd` (lines 77–81)</br>
*Belongs to:* [LogService](../../LogService.md)

**Signature**

```gdscript
func _get_fmt_time() -> String
```

## Description

get formatted time

## Source

```gdscript
func _get_fmt_time() -> String:
	var time := Time.get_datetime_dict_from_system()
	return "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
```
