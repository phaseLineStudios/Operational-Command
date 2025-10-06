# TerrainPolygonTool::_rebuild_info_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 231–278)</br>
*Belongs to:* [TerrainPolygonTool](../TerrainPolygonTool.md)

**Signature**

```gdscript
func _rebuild_info_ui()
```

## Description

Rebuild the Info UI with info on the active brush

## Source

```gdscript
func _rebuild_info_ui():
	if not _info_ui_parent || not active_brush:
		return

	_queue_free_children(_info_ui_parent)
	var l = RichTextLabel.new()
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.bbcode_enabled = true
	l.text = (
		"""
	[b]Selected feature[/b]
	%s

	[b]Movement Cost[/b]
	Foot: %d
	Wheeled: %d
	Tracked: %d
	Riverine: %d

	[b]LOS & Spotting[/b]
	Linear Attenuation: %d
	Spotting penalty (m): %d

	[b]Cover & Concealment[/b]
	Cover reduction: %d
	Concealment: %d

	[b]Special[/b]
	Road Bias: %d
	Bridge Capacity (t): %d
	"""
		% [
			active_brush.legend_title,
			active_brush.mv_foot,
			active_brush.mv_wheeled,
			active_brush.mv_tracked,
			active_brush.mv_riverine,
			active_brush.los_attenuation_per_m,
			active_brush.spotting_penalty_m,
			active_brush.cover_reduction,
			active_brush.concealment,
			active_brush.road_bias,
			active_brush.bridge_capacity_tons
		]
	)
	_info_ui_parent.add_child(l)
```
