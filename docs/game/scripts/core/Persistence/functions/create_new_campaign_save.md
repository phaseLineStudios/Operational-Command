# Persistence::create_new_campaign_save Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 24–27)</br>
*Belongs to:* [Persistence](../Persistence.md)

**Signature**

```gdscript
func create_new_campaign_save(_campaign_id: StringName) -> String
```

## Description

Create a new save for [param campaign_id]; return new ID.

## Source

```gdscript
func create_new_campaign_save(_campaign_id: StringName) -> String:
	# TODO: write initial save data; return new save id
	var new_id := "save_" + str(Time.get_unix_time_from_system())
	return new_id
```
