# HQTable::_init_test_scenario Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 397–422)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_test_scenario() -> void
```

## Source

```gdscript
func _init_test_scenario() -> void:
	Game.current_campaign = ContentDB.get_campaign("nato_1985_west_ger")
	Game.current_scenario = ContentDB.get_scenario("us_crested_cap")
	Game.current_scenario_loadout = {
		"assignments":
		[
			{"slot_id": "SLOT_1", "slot_key": "SLOT_1", "unit_id": "scout_plt_1a111_acr"},
			{
				"slot_id": "SLOT_2",
				"slot_key": "SLOT_2",
				"unit_id": "us_11acr_a_trp_2plt_tank_m60a3"
			},
			{"slot_id": "SLOT_3", "slot_key": "SLOT_3", "unit_id": "us_11acr_a_trp_itv_sec"},
			{
				"slot_id": "SLOT_4",
				"slot_key": "SLOT_4",
				"unit_id": "us_11acr_a_trp_mortar_sec_m106"
			},
			{"slot_id": "SLOT_5", "slot_key": "SLOT_5", "unit_id": "us_11acr_field_trains_sec"},
			{"slot_id": "SLOT_6", "slot_key": "SLOT_6", "unit_id": "us_11acr_58engr_pl"}
		],
		"mission_id": "us_crested_cap",
		"points_used": 319
	}
```
