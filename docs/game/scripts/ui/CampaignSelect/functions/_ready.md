# CampaignSelect::_ready Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 36–40)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Init UI, populate list, connect signals.

## Source

```gdscript
func _ready() -> void:
	_populate_campaigns()
	_connect_signals()
```
