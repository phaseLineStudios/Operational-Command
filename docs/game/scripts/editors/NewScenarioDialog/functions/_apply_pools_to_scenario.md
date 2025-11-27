# NewScenarioDialog::_apply_pools_to_scenario Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 354–386)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _apply_pools_to_scenario(sd: ScenarioData) -> void
```

## Description

Apply pool values from UI to ScenarioData.

## Source

```gdscript
func _apply_pools_to_scenario(sd: ScenarioData) -> void:
	sd.replacement_pool = int(replacement_pool_spin.value)
	sd.equipment_pool = int(equipment_pool_spin.value)

	sd.ammo_pools = {}
	if small_arms_spin.value > 0:
		sd.ammo_pools["SMALL_ARMS"] = int(small_arms_spin.value)
	if tank_gun_spin.value > 0:
		sd.ammo_pools["TANK_GUN"] = int(tank_gun_spin.value)
	if atgm_spin.value > 0:
		sd.ammo_pools["ATGM"] = int(atgm_spin.value)
	if at_rocket_spin.value > 0:
		sd.ammo_pools["AT_ROCKET"] = int(at_rocket_spin.value)
	if heavy_weapons_spin.value > 0:
		sd.ammo_pools["HEAVY_WEAPONS"] = int(heavy_weapons_spin.value)
	if autocannon_spin.value > 0:
		sd.ammo_pools["AUTOCANNON"] = int(autocannon_spin.value)
	if mortar_ap_spin.value > 0:
		sd.ammo_pools["MORTAR_AP"] = int(mortar_ap_spin.value)
	if mortar_smoke_spin.value > 0:
		sd.ammo_pools["MORTAR_SMOKE"] = int(mortar_smoke_spin.value)
	if mortar_illum_spin.value > 0:
		sd.ammo_pools["MORTAR_ILLUM"] = int(mortar_illum_spin.value)
	if artillery_ap_spin.value > 0:
		sd.ammo_pools["ARTILLERY_AP"] = int(artillery_ap_spin.value)
	if artillery_smoke_spin.value > 0:
		sd.ammo_pools["ARTILLERY_SMOKE"] = int(artillery_smoke_spin.value)
	if artillery_illum_spin.value > 0:
		sd.ammo_pools["ARTILLERY_ILLUM"] = int(artillery_illum_spin.value)
	if engineer_mun_spin.value > 0:
		sd.ammo_pools["ENGINEER_MUN"] = int(engineer_mun_spin.value)
```
