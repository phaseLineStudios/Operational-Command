# NewScenarioDialog::_load_pools_from_scenario Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 460–478)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _load_pools_from_scenario(d: ScenarioData) -> void
```

## Description

Load pool values from ScenarioData to UI.

## Source

```gdscript
func _load_pools_from_scenario(d: ScenarioData) -> void:
	replacement_pool_spin.value = float(d.replacement_pool)
	equipment_pool_spin.value = float(d.equipment_pool)

	small_arms_spin.value = float(d.ammo_pools.get("SMALL_ARMS", 0))
	tank_gun_spin.value = float(d.ammo_pools.get("TANK_GUN", 0))
	atgm_spin.value = float(d.ammo_pools.get("ATGM", 0))
	at_rocket_spin.value = float(d.ammo_pools.get("AT_ROCKET", 0))
	heavy_weapons_spin.value = float(d.ammo_pools.get("HEAVY_WEAPONS", 0))
	autocannon_spin.value = float(d.ammo_pools.get("AUTOCANNON", 0))
	mortar_ap_spin.value = float(d.ammo_pools.get("MORTAR_AP", 0))
	mortar_smoke_spin.value = float(d.ammo_pools.get("MORTAR_SMOKE", 0))
	mortar_illum_spin.value = float(d.ammo_pools.get("MORTAR_ILLUM", 0))
	artillery_ap_spin.value = float(d.ammo_pools.get("ARTILLERY_AP", 0))
	artillery_smoke_spin.value = float(d.ammo_pools.get("ARTILLERY_SMOKE", 0))
	artillery_illum_spin.value = float(d.ammo_pools.get("ARTILLERY_ILLUM", 0))
	engineer_mun_spin.value = float(d.ammo_pools.get("ENGINEER_MUN", 0))
```
