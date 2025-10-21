# ContourLayer Class Reference

*File:* `scripts/terrain/ContourLayer.gd`
*Class name:* `ContourLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name ContourLayer
extends Control
```

## Brief

Rebuild delay in seconds

Rebuild contours if elevation data changes

Resample a polyline to (roughly) uniform segment length 'step'.

## Detailed Description

Draw polyline while skipping arclength windows in `gaps`.

Draw subrange of a single segment given absolute arclengths

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](ContourLayer/functions/set_data.md) — API to set Terrain Data
- [`func apply_style(from: Node) -> void`](ContourLayer/functions/apply_style.md) — Apply root style
- [`func mark_dirty() -> void`](ContourLayer/functions/mark_dirty.md) — API to request contour rebuild
- [`func _notification(what)`](ContourLayer/functions/_notification.md) — Redraw contours on resize
- [`func _on_data_changed() -> void`](ContourLayer/functions/_on_data_changed.md) — Rebuild contours if terrain data changes
- [`func _schedule_rebuild() -> void`](ContourLayer/functions/_schedule_rebuild.md) — Schedule a Rebuild of the contour lines
- [`func _draw() -> void`](ContourLayer/functions/_draw.md)
- [`func _rebuild_contours() -> void`](ContourLayer/functions/_rebuild_contours.md) — Rebuild the contour lines
- [`func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array`](ContourLayer/functions/_march_level_segments.md) — March over segments for a level
- [`func _stitch_segments_to_polylines(segments: Array) -> Array`](ContourLayer/functions/_stitch_segments_to_polylines.md) — Stitch segments into polylines
- [`func _is_multiple(value: float, step: float) -> bool`](ContourLayer/functions/_is_multiple.md) — Helper function to check for multiple
- [`func _polyline_is_closed(pl: PackedVector2Array, eps := 0.01) -> bool`](ContourLayer/functions/_polyline_is_closed.md) — Helper to check if polyline is closed
- [`func _chaikin_once(pl: PackedVector2Array, closed: bool, keep_ends: bool) -> PackedVector2Array`](ContourLayer/functions/_chaikin_once.md) — One iteration of Chaikin corner cutting.
- [`func _get_base_offset() -> float`](ContourLayer/functions/_get_base_offset.md) — Get base elevation offset
- [`func _is_thick_level_abs(level: float) -> bool`](ContourLayer/functions/_is_thick_level_abs.md) — Check if thick level is absolute elevation
- [`func _layout_labels_on_line(line: PackedVector2Array, spacing: float) -> Array`](ContourLayer/functions/_layout_labels_on_line.md) — Compute cumulative length, place labels every `spacing` meters.
- [`func _draw_labels_for_placements(placements: Array, text: String) -> void`](ContourLayer/functions/_draw_labels_for_placements.md) — Draw the text plaques using precomputed placements

## Public Attributes

- `Color contour_color` — Base contour color
- `Color contour_thick_color` — Contour color for thick lines
- `float contour_px` — Base width for contour lines
- `int contour_thick_every_m` — How often should contour lines be thick (in m)
- `int smooth_iterations` — Smoothing iterations
- `float smooth_segment_len_m` — Smoothing segment lengths
- `bool smooth_keep_ends` — Should smoothing keep ends
- `int contour_label_every_m` — Contour label spacing
- `bool contour_label_on_thick_only` — Only show elevation label on thick contours
- `Color contour_label_color` — Contour label color
- `Color contour_label_bg` — Contour label background
- `float contour_label_padding_px` — Contour label padding
- `Font contour_label_font` — Contour label font
- `int contour_label_size` — Contour label font size
- `float contour_label_gap_extra_px` — Extra space beyond plaque width
- `TerrainData data`
- `PackedFloat32Array _levels`
- `Dictionary _polylines_by_level`
- `float level_seg`
- `Array cleaned`
- `int a`
- `int b`
- `Array merged`
- `float left`

## Member Function Documentation

### set_data

```gdscript
func set_data(d: TerrainData) -> void
```

API to set Terrain Data

### apply_style

```gdscript
func apply_style(from: Node) -> void
```

Apply root style

### mark_dirty

```gdscript
func mark_dirty() -> void
```

API to request contour rebuild

### _notification

```gdscript
func _notification(what)
```

Redraw contours on resize

### _on_data_changed

```gdscript
func _on_data_changed() -> void
```

Rebuild contours if terrain data changes

### _schedule_rebuild

```gdscript
func _schedule_rebuild() -> void
```

Schedule a Rebuild of the contour lines

### _draw

```gdscript
func _draw() -> void
```

### _rebuild_contours

```gdscript
func _rebuild_contours() -> void
```

Rebuild the contour lines

### _march_level_segments

```gdscript
func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array
```

March over segments for a level

### _stitch_segments_to_polylines

```gdscript
func _stitch_segments_to_polylines(segments: Array) -> Array
```

Stitch segments into polylines

### _is_multiple

```gdscript
func _is_multiple(value: float, step: float) -> bool
```

Helper function to check for multiple

### _polyline_is_closed

```gdscript
func _polyline_is_closed(pl: PackedVector2Array, eps := 0.01) -> bool
```

Helper to check if polyline is closed

### _chaikin_once

```gdscript
func _chaikin_once(pl: PackedVector2Array, closed: bool, keep_ends: bool) -> PackedVector2Array
```

One iteration of Chaikin corner cutting.

### _get_base_offset

```gdscript
func _get_base_offset() -> float
```

Get base elevation offset

### _is_thick_level_abs

```gdscript
func _is_thick_level_abs(level: float) -> bool
```

Check if thick level is absolute elevation

### _layout_labels_on_line

```gdscript
func _layout_labels_on_line(line: PackedVector2Array, spacing: float) -> Array
```

Compute cumulative length, place labels every `spacing` meters.

### _draw_labels_for_placements

```gdscript
func _draw_labels_for_placements(placements: Array, text: String) -> void
```

Draw the text plaques using precomputed placements

## Member Data Documentation

### contour_color

```gdscript
var contour_color: Color
```

Decorators: `@export`

Base contour color

### contour_thick_color

```gdscript
var contour_thick_color: Color
```

Decorators: `@export`

Contour color for thick lines

### contour_px

```gdscript
var contour_px: float
```

Decorators: `@export`

Base width for contour lines

### contour_thick_every_m

```gdscript
var contour_thick_every_m: int
```

Decorators: `@export`

How often should contour lines be thick (in m)

### smooth_iterations

```gdscript
var smooth_iterations: int
```

Decorators: `@export`

Smoothing iterations

### smooth_segment_len_m

```gdscript
var smooth_segment_len_m: float
```

Decorators: `@export`

Smoothing segment lengths

### smooth_keep_ends

```gdscript
var smooth_keep_ends: bool
```

Decorators: `@export`

Should smoothing keep ends

### contour_label_every_m

```gdscript
var contour_label_every_m: int
```

Decorators: `@export`

Contour label spacing

### contour_label_on_thick_only

```gdscript
var contour_label_on_thick_only: bool
```

Decorators: `@export`

Only show elevation label on thick contours

### contour_label_color

```gdscript
var contour_label_color: Color
```

Decorators: `@export`

Contour label color

### contour_label_bg

```gdscript
var contour_label_bg: Color
```

Decorators: `@export`

Contour label background

### contour_label_padding_px

```gdscript
var contour_label_padding_px: float
```

Decorators: `@export`

Contour label padding

### contour_label_font

```gdscript
var contour_label_font: Font
```

Decorators: `@export`

Contour label font

### contour_label_size

```gdscript
var contour_label_size: int
```

Decorators: `@export`

Contour label font size

### contour_label_gap_extra_px

```gdscript
var contour_label_gap_extra_px: float
```

Decorators: `@export`

Extra space beyond plaque width

### data

```gdscript
var data: TerrainData
```

### _levels

```gdscript
var _levels: PackedFloat32Array
```

### _polylines_by_level

```gdscript
var _polylines_by_level: Dictionary
```

### level_seg

```gdscript
var level_seg: float
```

### cleaned

```gdscript
var cleaned: Array
```

### a

```gdscript
var a: int
```

### b

```gdscript
var b: int
```

### merged

```gdscript
var merged: Array
```

### left

```gdscript
var left: float
```
