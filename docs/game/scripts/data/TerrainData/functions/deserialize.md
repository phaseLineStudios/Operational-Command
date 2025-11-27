# TerrainData::deserialize Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 572–678)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func deserialize(d: Variant) -> TerrainData
```

## Description

Deserialize from JSON

## Source

```gdscript
static func deserialize(d: Variant) -> TerrainData:
	if typeof(d) != TYPE_DICTIONARY:
		return null

	var t := TerrainData.new()

	t.name = d.get("name", t.name)
	t.terrain_id = d.get("id", t.terrain_id)
	t.width_m = int(d.get("width_m", t.width_m))
	t.height_m = int(d.get("height_m", t.height_m))
	t.elevation_resolution_m = int(d.get("elevation_resolution_m", t.elevation_resolution_m))

	var grid: Dictionary = d.get("grid", {})
	if typeof(grid) == TYPE_DICTIONARY:
		t.grid_start_x = int(grid.get("start_x", t.grid_start_x))
		t.grid_start_y = int(grid.get("start_y", t.grid_start_y))

	var em: Dictionary = d.get("elev_meta", {})
	if typeof(em) == TYPE_DICTIONARY:
		t.base_elevation_m = int(em.get("base_elevation_m", t.base_elevation_m))
		t.contour_interval_m = int(em.get("contour_interval_m", t.contour_interval_m))

	var elev: Dictionary = d.get("elevation", {})
	if typeof(elev) == TYPE_DICTIONARY:
		var b64: String = elev.get("png_b64", null)
		if b64 != null and typeof(b64) == TYPE_STRING and b64 != "":
			var img := ContentDB.png_b64_to_image(b64)
			if not img.is_empty():
				t.elevation = img
				t._resample_or_resize()
				t._update_scale()

	var content: Dictionary = d.get("content", {})
	if typeof(content) == TYPE_DICTIONARY:
		var srf_in: Array = content.get("surfaces", [])
		if typeof(srf_in) == TYPE_ARRAY:
			var srf_out: Array = []
			for s in srf_in:
				if typeof(s) != TYPE_DICTIONARY:
					continue
				var entry := {
					"id": int(s.get("id", 0)),
					"type": s.get("type", null),
					"points": ContentDB.v2arr_deserialize(s.get("points", [])),
					"closed": bool(s.get("closed", false))
				}
				var bp: String = s.get("brush_path", null)
				if bp is String and bp != "":
					entry["brush"] = ContentDB.load_res(bp)
				srf_out.append(entry)
			t.surfaces = srf_out

		var ln_in: Array = content.get("lines", [])
		if typeof(ln_in) == TYPE_ARRAY:
			var ln_out: Array = []
			for l in ln_in:
				if typeof(l) != TYPE_DICTIONARY:
					continue
				var entry := {
					"id": int(l.get("id", 0)),
					"points": ContentDB.v2arr_deserialize(l.get("points", [])),
					"closed": bool(l.get("closed", false)),
					"width_px": float(l.get("width_px", 1.0))
				}
				var bp: String = l.get("brush_path", null)
				if bp is String and bp != "":
					entry["brush"] = ContentDB.load_res(bp)
				ln_out.append(entry)
			t.lines = ln_out

		var pt_in: Array = content.get("points", [])
		if typeof(pt_in) == TYPE_ARRAY:
			var pt_out: Array = []
			for p in pt_in:
				if typeof(p) != TYPE_DICTIONARY:
					continue
				var entry := {
					"id": int(p.get("id", 0)),
					"pos": ContentDB.v2_from(p.get("pos", ContentDB.v2(Vector2.ZERO))),
					"rot": float(p.get("rot", 0.0)),
					"scale": float(p.get("scale", 1.0))
				}
				var bp: String = p.get("brush_path", null)
				if bp is String and bp != "":
					entry["brush"] = ContentDB.load_res(bp)
				pt_out.append(entry)
			t.points = pt_out

		var lab_in: Array = content.get("labels", [])
		if typeof(lab_in) == TYPE_ARRAY:
			var lab_out: Array = []
			for lab in lab_in:
				if typeof(lab) != TYPE_DICTIONARY:
					continue
				lab_out.append(
					{
						"id": int(lab.get("id", 0)),
						"text": String(lab.get("text", "")),
						"pos": ContentDB.v2_from(lab.get("pos", ContentDB.v2(Vector2.ZERO))),
						"size": int(lab.get("size", 16)),
						"rot": float(lab.get("rot", 0.0)),
						"z": int(lab.get("z", 0))
					}
				)
			t.labels = lab_out

	return t
```
