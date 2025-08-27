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
	"briefing": "wg_exercise_reforger_brief",
	"terrain": "wg_reforger_terrain",
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
	"id": "wg_exercise_reforger_brief", 
	"title": "Operation BRAVO LINE",
	"situation": { 
		"enemy": "MRB assembling east of PL BRAVO; armor mix T-72/BMP.", 
		"friendly": "A/1-36 IN (-) with attached Hvy Weapons Plt.", 
		"terrain": "Rolling with wooded draws; bridges over the Jossa.", 
		"weather": { "wind": "NE 5kt", "vis_km": 10 },
		"start_time": "1984-09-22T05:30:00Z"
	},
	"mission": {
		"mission": "Delay and trade space for time...",
		"objectives": [ 
			{ "id": "obj_secure_bridge", "type": "SECURE", "title": "Secure the bridge", "success": "Hold 15 minutes", "score": 100 }, 
			{ "id": "obj_hold_msrs", "type": "HOLD", "title": "Hold MSR nodes", "score": 200 } 
		]
	}, 
	"execution": ["Phase I: Recon pull", "Phase II: Delay"], 
	"admin_log": "Ammo limited. Keep losses low.", 
	"board": { 
		"background": "res://assets/ui/whiteboard.png", 
		"items": [ 
			{ 
				"id": "intel_photo", 
				"title": "Recon Photo – MSR", 
				"type": "image", 
				"resource": "res://maps/intel/wg_reforger/recon_photo_01.png", 
				"pos": [0.62, 0.22] 
			}, 
			{ 
				"id": "sigint", 
				"title": "SIGINT Summary", 
				"type": "text", 
				"resource": "res://maps/intel/wg_reforger/sigint_summary.bbcode", 
				"pos": [0.42, 0.62]
			}
		] 
	}
}
```
