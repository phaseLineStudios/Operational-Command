# data/
Authoritative JSON databases used by ContentDB.

## Subfolders
- `units/` — Tables of Organization & Equipment, combat stats.
- `maps/` — Map metadata, overlays, spawn zones, environment.
- `briefs/` — Mission briefs, intel packets, objectives.

## Conventions
- File name (without extension) is the stable `id`.
- JSON is schema-checked at load; unknown keys are warned, missing required keys error.

## Mini Schemas
### Unit (units/<id>.json)
```json
{
  "id": "wg_panzer_platoon_m60",
  "name": "Panzer Platoon (M60A3)",
  "type": "armor",
  "size": "platoon",
  "personnel": 16,
  "equipment": { "M60A3": 4 },
  "stats": {
	"attack": 65,
	"defense": 55,
	"spot": 1800,
	"range": 2500,
	"morale": 70,
	"speed_kph": 45
  },
  "doctrine": "nato_armor_1984"
}
```

### Map (maps/<id>.json)
```json
{
  "id": "fulda_gap_north",
  "display_name": "Fulda Gap (North)",
  "raster": "res://maps/fulda_gap_north/tiles.png",
  "heightmap": "res://maps/fulda_gap_north/height.png",
  "grid": { "meters_per_cell": 10, "origin": [0, 0] },
  "spawn_zones": { "nato": [[100,200],[300,200]], "wp": [[1500,900]] },
  "features": { "roads": "res://maps/fulda_gap_north/roads.tres" },
  "environment": { "time": "1984-08-14T05:30:00Z", "weather": "overcast" }
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
