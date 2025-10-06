# SurfaceLayer::_rec_key Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 590–610)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _rec_key(rec: Dictionary) -> String
```

## Description

Produces a stable batching key based on draw state (z/mode/colors/texture)

## Source

```gdscript
func _rec_key(rec: Dictionary) -> String:
	var z := str(int(rec.z_index if rec.has("z_index") else 0))
	var mode := str(int(rec.mode if rec.has("mode") else 0))
	var fcol: Color = (
		Color(rec.fill.color) if (rec.has("fill") and "color" in rec.fill) else Color(0, 0, 0, 0)
	)
	var scol: Color = (
		Color(rec.stroke.color)
		if (rec.has("stroke") and "color" in rec.stroke)
		else Color(0, 0, 0, 0)
	)
	var sw: float = float(
		rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
	)
	var tex: Texture2D = rec.symbol.tex if (rec.has("symbol") and "tex" in rec.symbol) else null
	var tex_id := ""
	if tex != null:
		tex_id = (
			tex.resource_path if tex.resource_path != "" else "rid:%s" % tex.get_instance_id()
		)
	return "%s|%s|%s|%s|%f|%s" % [z, mode, fcol.to_html(), scol.to_html(), sw, tex_id]
```
