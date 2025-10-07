# TerrainData::serialize Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 489–563)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize terrain to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	var elev_b64: Variant = null
	if elevation and not elevation.is_empty():
		elev_b64 = ContentDB.image_to_png_b64(elevation)

	var srf_out: Array = []
	for s in surfaces:
		if typeof(s) != TYPE_DICTIONARY:
			continue
		srf_out.append(
			{
				"id": int(s.get("id", 0)),
				"brush_path": ContentDB.res_path_or_null(s.get("brush", null)),
				"type": s.get("type", null),
				"points": ContentDB.v2arr_serialize(s.get("points", PackedVector2Array())),
				"closed": bool(s.get("closed", false))
			}
		)

	var ln_out: Array = []
	for l in lines:
		if typeof(l) != TYPE_DICTIONARY:
			continue
		ln_out.append(
			{
				"id": int(l.get("id", 0)),
				"brush_path": ContentDB.res_path_or_null(l.get("brush", null)),
				"points": ContentDB.v2arr_serialize(l.get("points", PackedVector2Array())),
				"closed": bool(l.get("closed", false)),
				"width_px": float(l.get("width_px", 1.0))
			}
		)

	var pt_out: Array = []
	for p in points:
		if typeof(p) != TYPE_DICTIONARY:
			continue
		pt_out.append(
			{
				"id": int(p.get("id", 0)),
				"brush_path": ContentDB.res_path_or_null(p.get("brush", null)),
				"pos": ContentDB.v2(p.get("pos", Vector2.ZERO)),
				"rot": float(p.get("rot", 0.0)),
				"scale": float(p.get("scale", 1.0))
			}
		)

	var lab_out: Array = []
	for lab in labels:
		if typeof(lab) != TYPE_DICTIONARY:
			continue
		lab_out.append(
			{
				"id": int(lab.get("id", 0)),
				"text": String(lab.get("text", "")),
				"pos": ContentDB.v2(lab.get("pos", Vector2.ZERO)),
				"size": int(lab.get("size", 16)),
				"rot": float(lab.get("rot", 0.0)),
				"z": int(lab.get("z", 0))
			}
		)

	return {
		"name": name,
		"width_m": width_m,
		"height_m": height_m,
		"elevation_resolution_m": elevation_resolution_m,
		"grid": {"start_x": grid_start_x, "start_y": grid_start_y},
		"elevation": {"png_b64": elev_b64},
		"elev_meta":
		{"base_elevation_m": base_elevation_m, "contour_interval_m": contour_interval_m},
		"content": {"surfaces": srf_out, "lines": ln_out, "points": pt_out, "labels": lab_out}
	}
```
