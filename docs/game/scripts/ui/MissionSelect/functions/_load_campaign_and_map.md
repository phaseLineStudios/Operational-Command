# MissionSelect::_load_campaign_and_map Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 69–84)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _load_campaign_and_map() -> void
```

## Description

Load current campaign + map.

## Source

```gdscript
func _load_campaign_and_map() -> void:
	_campaign = Game.current_campaign
	if not _campaign:
		push_warning("MissionSelect: No current campaign set.")
		return

	if _campaign.scenario_bg:
		_map_rect.texture = _campaign.scenario_bg
	else:
		push_warning("MissionSelect: Failed to load map: %s" % _campaign.scenario_bg)

	_scenarios = ContentDB.list_scenarios_for_campaign(_campaign.id)
	if _scenarios.is_empty():
		push_warning("MissionSelect: Campaign has no missions.")
```
