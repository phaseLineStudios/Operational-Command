# CampaignSave::touch Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 63–66)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func touch() -> void
```

## Description

Update last played timestamp.

## Source

```gdscript
func touch() -> void:
	last_played_timestamp = int(Time.get_unix_time_from_system())
```
