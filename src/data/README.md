# data/
Authoritative JSON databases used by ContentDB.

## Subfolders
- `units/` — Tables of Organization & Equipment, combat stats.
- `campaigns/` — Campaign packages and data
- `missions/` — Individual mission data
- `briefs/` — Mission briefs, intel packets, objectives.

## Conventions
- File name (without extension) is the stable `id`.
- JSON is schema-checked at load; unknown keys are warned, missing required keys error.

## Mini Schemas
### Unit (units/<id>.json)
```json
{
	"id": "heavy_weapons_plt_1",
	"title": "1st Heavy Weapons Platoon",
	"role": "SUPPORT",
	"cost": 80,
	"size": "platoon",
	"personnel": 21,
	"equipment": { "M2HB": 4, "FGM77": 2 },
	"veterancy": "REGULAR",
	"stats": {
		"attack": 85,
		"defense": 55,
		"spot_m": 1800,
		"range_m": 2500,
		"morale": 0.8,
		"speed_kph": 4
	},
	"state": {
		"personnel_ratio": 0.85,
		"equipment_ratio": 0.90,
		"cohesion": 0.70
	},
	"throughput": ["ammo_100"],          // Logistics for other units
	"equipment_tags": ["ammo_pallet"],   // Logistics Flavor
	"icon": "",
	"allowed_slots": ["INF_SLOT", "SUPPORT_SLOT", "RESERVE_ANY", "RESERVE_INF", "RESERVE_SUPPORT"],
	"doctrine": "nato_hww_1984"
}

```

### Campaign (campaigns/<id>.json)
```json
{
	"id": "nato_1985_west_ger",
	"title": "NATO 1985 – West German Front",
	"blurb": "Defensive to counteroffensive along the Inner German Border.",
	"image": "res://maps/previews/west_ger_preview.png",
	"campaign_map": "res://maps/campaign/west_ger_map.png",
	"missions": ["wg_exercise_reforger"],
	"order": 0
}
```

### Mission (missions/<id>.json)
```json
{
	"id": "wg_exercise_reforger",
	"title": "Exercise Reforger 85'",
	"description": "Annual NATO exercise held in West Germany.",
	"image": "res://maps/previews/wg_exercise_reforger.png",
	"difficulty": "Easy",
	"pos": Vector2(0.44, 0.40),
	"order": 0,
	"unit_points": 1250,
	"unit_slots": [
		{ "key": "COMPANY_HQ", "title": "Company HQ", "allowed_roles": ["HQ"] },
		{ "key": "PLT_1", "title": "1st Platoon (ALPHA)", "allowed_roles": ["INF", "MECH", "ARMOR", "SUPPORT"] },
		{ "key": "PLT_2", "title": "2nd Platoon (BRAVO)", "allowed_roles": ["INF", "MECH", "ARMOR", "SUPPORT"] },
		{ "key": "WEAPONS", "title": "Weapons (CHARLIE)", "allowed_roles": ["SUPPORT"] }
	],
	"recruitable_units": ["heavy_weapons_plt_1"],
	"has_reserve_unit": true
}
```

### Brief (briefs/<id>.json)
```json
{
  "id": "op_bravo_line",
  "title": "Operation BRAVO LINE",
  "situation": "WP forces crossing at point CHARLIE...",
  "mission": "Delay and trade space for time...",
  "execution": ["Phase I: Recon pull", "Phase II: Delay"],
  "admin_log": "Ammo limited. Keep losses low.",
  "signals": { "net": "Alpha", "callsigns": { "HQ": "Razor", "1PLT": "Viper-1" } },
  "objectives": [
	{ "id": "OBJ_DELAY_30", "type": "delay", "score": 100 }
  ]
}
```
