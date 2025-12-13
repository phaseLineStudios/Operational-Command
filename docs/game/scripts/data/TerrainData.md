# TerrainData Class Reference

*File:* `scripts/data/TerrainData.gd`
*Class name:* `TerrainData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name TerrainData
extends Resource
```

## Brief

Terrain model: size, elevation, surfaces, features, labels.

## Public Member Functions

- [`func begin_batch() -> void`](TerrainData/functions/begin_batch.md) — Begin a batch - defers granular signals until end_batch().
- [`func end_batch() -> void`](TerrainData/functions/end_batch.md) — End a batch - emits coalesced signals.
- [`func _emit_coalesced(pend: Array, sig: Signal) -> void`](TerrainData/functions/_emit_coalesced.md)
- [`func _init() -> void`](TerrainData/functions/_init.md)
- [`func _set_width(v: int) -> void`](TerrainData/functions/_set_width.md)
- [`func _set_height(v: int) -> void`](TerrainData/functions/_set_height.md)
- [`func _set_resolution(v: int) -> void`](TerrainData/functions/_set_resolution.md)
- [`func _set_grid_x(_v: int) -> void`](TerrainData/functions/_set_grid_x.md)
- [`func _set_grid_y(_v: int) -> void`](TerrainData/functions/_set_grid_y.md)
- [`func _set_elev(img: Image) -> void`](TerrainData/functions/_set_elev.md)
- [`func _set_contour_interval_m(v)`](TerrainData/functions/_set_contour_interval_m.md)
- [`func _set_surfaces(v) -> void`](TerrainData/functions/_set_surfaces.md)
- [`func _set_lines(v) -> void`](TerrainData/functions/_set_lines.md)
- [`func _set_points(v) -> void`](TerrainData/functions/_set_points.md)
- [`func _set_labels(v) -> void`](TerrainData/functions/_set_labels.md)
- [`func add_surface(s: Dictionary) -> int`](TerrainData/functions/add_surface.md) — Add a new surface.
- [`func set_surface_points(id: int, pts: PackedVector2Array) -> void`](TerrainData/functions/set_surface_points.md) — Update surface points by id (fast path while drawing).
- [`func set_surface_brush(id: int, brush: Resource) -> void`](TerrainData/functions/set_surface_brush.md) — Update surface brush or metadata by id.
- [`func remove_surface(id: int) -> void`](TerrainData/functions/remove_surface.md) — Remove surface by id.
- [`func add_line(l: Dictionary) -> int`](TerrainData/functions/add_line.md) — Add a new line.
- [`func set_line_points(id: int, pts: PackedVector2Array) -> void`](TerrainData/functions/set_line_points.md) — Update line points by id (fast path while drawing).
- [`func set_line_style(id: int, width_px: float) -> void`](TerrainData/functions/set_line_style.md) — Update line style.
- [`func set_line_brush(id: int, brush: TerrainBrush) -> void`](TerrainData/functions/set_line_brush.md) — Update line brush by id.
- [`func remove_line(id: int) -> void`](TerrainData/functions/remove_line.md) — Remove line by id.
- [`func add_point(p: Dictionary) -> int`](TerrainData/functions/add_point.md) — Add a new point.
- [`func set_point_transform(id: int, pos: Vector2, rot: float, scale: float = 1.0) -> void`](TerrainData/functions/set_point_transform.md) — Update points transformation
- [`func remove_point(id: int) -> void`](TerrainData/functions/remove_point.md) — Remove point by id
- [`func add_label(lab: Dictionary) -> int`](TerrainData/functions/add_label.md) — Add a new label.
- [`func set_label_pose(id: int, pos: Vector2, rot: float) -> void`](TerrainData/functions/set_label_pose.md) — Update labels transform by id
- [`func set_label_style(id: int, size: int) -> void`](TerrainData/functions/set_label_style.md) — Update labelstyle or metadata by id
- [`func remove_label(id: int) -> void`](TerrainData/functions/remove_label.md) — Remove label by id
- [`func get_elevation_block(rect: Rect2i) -> PackedFloat32Array`](TerrainData/functions/get_elevation_block.md) — Returns a row-major block of elevation samples (r channel) for the clipped rect.
- [`func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void`](TerrainData/functions/set_elevation_block.md) — Writes a row-major block of elevation samples (r channel) into the clipped rect.
- [`func get_size() -> Vector2`](TerrainData/functions/get_size.md) — Get terrain size (meters).
- [`func get_elev_px(px: Vector2i) -> float`](TerrainData/functions/get_elev_px.md) — Get elevation (meters) at sample coord.
- [`func set_elev_px(px: Vector2i, meters: float) -> void`](TerrainData/functions/set_elev_px.md) — Set elevation (meters) at sample coord.
- [`func world_to_elev_px(p: Vector2) -> Vector2i`](TerrainData/functions/world_to_elev_px.md) — Convert world meters to elevation pixel coords.
- [`func elev_px_to_world(px: Vector2i) -> Vector2`](TerrainData/functions/elev_px_to_world.md) — Convert elevation pixel coords to world meters (top-left origin).
- [`func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i`](TerrainData/functions/_clip_rect_to_image.md) — Helper function to clip a rect to image bounds
- [`func _update_scale() -> void`](TerrainData/functions/_update_scale.md) — Update heightmap scale
- [`func _resample_or_resize() -> void`](TerrainData/functions/_resample_or_resize.md) — Resmaple or resize heightmap
- [`func _ensure_ids(arr: Array, counter_prop: String) -> Array`](TerrainData/functions/_ensure_ids.md) — Ensure IDs are unique
- [`func _ensure_id_on_item(item: Dictionary, counter_prop: String) -> int`](TerrainData/functions/_ensure_id_on_item.md) — Ensure item has ID
- [`func _collect_ids(arr: Array) -> PackedInt32Array`](TerrainData/functions/_collect_ids.md) — Collect valid IDs
- [`func _find_by_id(arr: Array, id: int) -> int`](TerrainData/functions/_find_by_id.md) — Find item by ID
- [`func _queue_emit(bucket: Array, kind: String, ids: PackedInt32Array, sig_name: String) -> void`](TerrainData/functions/_queue_emit.md) — Queue up signal emits
- [`func serialize() -> Dictionary`](TerrainData/functions/serialize.md) — Serialize terrain to JSON
- [`func deserialize(d: Variant) -> TerrainData`](TerrainData/functions/deserialize.md) — Deserialize from JSON

## Public Attributes

- `String terrain_id` — unique terrain identifier
- `String: name` — Name of the terrain.
- `int width_m` — Width of the map in meters.
- `int height_m` — Height of the map in meters.
- `int elevation_resolution_m` — World meters per elevation sample (grid step).
- `String country` — Country or region
- `String map_scale` — Map scale (always 1:25,000)
- `String edition` — Map edition number
- `String series` — Map series identifier
- `String sheet` — Map sheet identifier
- `int grid_start_x` — Starting number on X axis labels.
- `int grid_start_y` — Starting number on Y axis labels.
- `int base_elevation_m` — The base elevation of the terrain in meters.
- `int contour_interval_m` — Contour interval in meters.
- `Image elevation` — Elevation image (R channel = meters; 16F or 32F preferred).
- `Array surfaces` — Surfaces: { id:int, brush:TerrainBrush, type:String, points:PackedVector2Array, closed:bool }.
- `Array lines` — Lines: { id:int, brush:TerrainBrush, points:PackedVector2Array, closed:bool, width_px:float }.
- `Array points` — Points: { id:int, brush:TerrainBrush, pos:Vector2, rot:float, scale:float }.
- `Array labels` — Labels: { id:int, text:String, pos:Vector2, size:int, rot:float, z:int }.
- `float _px_per_m`
- `Array _pend_surfaces`
- `Array _pend_lines`
- `Array _pend_points`
- `Array _pend_labels`

## Signals

- `signal elevation_changed(rect: Rect2i)` — Emits when the elevation image block changes.
- `signal surfaces_changed(kind: String, ids: PackedInt32Array)` — Emits when surfaces mutate.
- `signal lines_changed(kind: String, ids: PackedInt32Array)` — Emits when lines mutate.
- `signal points_changed(kind: String, ids: PackedInt32Array)` — Emits when points mutate.
- `signal labels_changed(kind: String, ids: PackedInt32Array)` — Emits when labels mutate.

## Member Function Documentation

### begin_batch

```gdscript
func begin_batch() -> void
```

Begin a batch - defers granular signals until end_batch().

### end_batch

```gdscript
func end_batch() -> void
```

End a batch - emits coalesced signals.

### _emit_coalesced

```gdscript
func _emit_coalesced(pend: Array, sig: Signal) -> void
```

### _init

```gdscript
func _init() -> void
```

### _set_width

```gdscript
func _set_width(v: int) -> void
```

### _set_height

```gdscript
func _set_height(v: int) -> void
```

### _set_resolution

```gdscript
func _set_resolution(v: int) -> void
```

### _set_grid_x

```gdscript
func _set_grid_x(_v: int) -> void
```

### _set_grid_y

```gdscript
func _set_grid_y(_v: int) -> void
```

### _set_elev

```gdscript
func _set_elev(img: Image) -> void
```

### _set_contour_interval_m

```gdscript
func _set_contour_interval_m(v)
```

### _set_surfaces

```gdscript
func _set_surfaces(v) -> void
```

### _set_lines

```gdscript
func _set_lines(v) -> void
```

### _set_points

```gdscript
func _set_points(v) -> void
```

### _set_labels

```gdscript
func _set_labels(v) -> void
```

### add_surface

```gdscript
func add_surface(s: Dictionary) -> int
```

Add a new surface. Returns the assigned id.

### set_surface_points

```gdscript
func set_surface_points(id: int, pts: PackedVector2Array) -> void
```

Update surface points by id (fast path while drawing).

### set_surface_brush

```gdscript
func set_surface_brush(id: int, brush: Resource) -> void
```

Update surface brush or metadata by id.

### remove_surface

```gdscript
func remove_surface(id: int) -> void
```

Remove surface by id.

### add_line

```gdscript
func add_line(l: Dictionary) -> int
```

Add a new line. Returns the assigned id.

### set_line_points

```gdscript
func set_line_points(id: int, pts: PackedVector2Array) -> void
```

Update line points by id (fast path while drawing).

### set_line_style

```gdscript
func set_line_style(id: int, width_px: float) -> void
```

Update line style.

### set_line_brush

```gdscript
func set_line_brush(id: int, brush: TerrainBrush) -> void
```

Update line brush by id.

### remove_line

```gdscript
func remove_line(id: int) -> void
```

Remove line by id.

### add_point

```gdscript
func add_point(p: Dictionary) -> int
```

Add a new point. Returns the assigned id.

### set_point_transform

```gdscript
func set_point_transform(id: int, pos: Vector2, rot: float, scale: float = 1.0) -> void
```

Update points transformation

### remove_point

```gdscript
func remove_point(id: int) -> void
```

Remove point by id

### add_label

```gdscript
func add_label(lab: Dictionary) -> int
```

Add a new label. Returns the assigned id

### set_label_pose

```gdscript
func set_label_pose(id: int, pos: Vector2, rot: float) -> void
```

Update labels transform by id

### set_label_style

```gdscript
func set_label_style(id: int, size: int) -> void
```

Update labelstyle or metadata by id

### remove_label

```gdscript
func remove_label(id: int) -> void
```

Remove label by id

### get_elevation_block

```gdscript
func get_elevation_block(rect: Rect2i) -> PackedFloat32Array
```

Returns a row-major block of elevation samples (r channel) for the clipped rect.

### set_elevation_block

```gdscript
func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void
```

Writes a row-major block of elevation samples (r channel) into the clipped rect.

### get_size

```gdscript
func get_size() -> Vector2
```

Get terrain size (meters).

### get_elev_px

```gdscript
func get_elev_px(px: Vector2i) -> float
```

Get elevation (meters) at sample coord.

### set_elev_px

```gdscript
func set_elev_px(px: Vector2i, meters: float) -> void
```

Set elevation (meters) at sample coord.

### world_to_elev_px

```gdscript
func world_to_elev_px(p: Vector2) -> Vector2i
```

Convert world meters to elevation pixel coords.

### elev_px_to_world

```gdscript
func elev_px_to_world(px: Vector2i) -> Vector2
```

Convert elevation pixel coords to world meters (top-left origin).

### _clip_rect_to_image

```gdscript
func _clip_rect_to_image(rect: Rect2i, img: Image) -> Rect2i
```

Helper function to clip a rect to image bounds

### _update_scale

```gdscript
func _update_scale() -> void
```

Update heightmap scale

### _resample_or_resize

```gdscript
func _resample_or_resize() -> void
```

Resmaple or resize heightmap

### _ensure_ids

```gdscript
func _ensure_ids(arr: Array, counter_prop: String) -> Array
```

Ensure IDs are unique

### _ensure_id_on_item

```gdscript
func _ensure_id_on_item(item: Dictionary, counter_prop: String) -> int
```

Ensure item has ID

### _collect_ids

```gdscript
func _collect_ids(arr: Array) -> PackedInt32Array
```

Collect valid IDs

### _find_by_id

```gdscript
func _find_by_id(arr: Array, id: int) -> int
```

Find item by ID

### _queue_emit

```gdscript
func _queue_emit(bucket: Array, kind: String, ids: PackedInt32Array, sig_name: String) -> void
```

Queue up signal emits

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize terrain to JSON

### deserialize

```gdscript
func deserialize(d: Variant) -> TerrainData
```

Deserialize from JSON

## Member Data Documentation

### terrain_id

```gdscript
var terrain_id: String
```

Decorators: `@export`

unique terrain identifier

### name

```gdscript
var name: String:
```

Decorators: `@export`

Name of the terrain.

### width_m

```gdscript
var width_m: int
```

Decorators: `@export`

Width of the map in meters.

### height_m

```gdscript
var height_m: int
```

Decorators: `@export`

Height of the map in meters.

### elevation_resolution_m

```gdscript
var elevation_resolution_m: int
```

Decorators: `@export`

World meters per elevation sample (grid step). Lower = denser.

### country

```gdscript
var country: String
```

Decorators: `@export`

Country or region

### map_scale

```gdscript
var map_scale: String
```

Decorators: `@export`

Map scale (always 1:25,000)

### edition

```gdscript
var edition: String
```

Decorators: `@export`

Map edition number

### series

```gdscript
var series: String
```

Decorators: `@export`

Map series identifier

### sheet

```gdscript
var sheet: String
```

Decorators: `@export`

Map sheet identifier

### grid_start_x

```gdscript
var grid_start_x: int
```

Decorators: `@export`

Starting number on X axis labels.

### grid_start_y

```gdscript
var grid_start_y: int
```

Decorators: `@export`

Starting number on Y axis labels.

### base_elevation_m

```gdscript
var base_elevation_m: int
```

Decorators: `@export`

The base elevation of the terrain in meters.

### contour_interval_m

```gdscript
var contour_interval_m: int
```

Decorators: `@export`

Contour interval in meters.

### elevation

```gdscript
var elevation: Image
```

Decorators: `@export`

Elevation image (R channel = meters; 16F or 32F preferred).

### surfaces

```gdscript
var surfaces: Array
```

Decorators: `@export`

Surfaces: { id:int, brush:TerrainBrush, type:String, points:PackedVector2Array, closed:bool }.

### lines

```gdscript
var lines: Array
```

Decorators: `@export`

Lines: { id:int, brush:TerrainBrush, points:PackedVector2Array, closed:bool, width_px:float }.

### points

```gdscript
var points: Array
```

Decorators: `@export`

Points: { id:int, brush:TerrainBrush, pos:Vector2, rot:float, scale:float }.

### labels

```gdscript
var labels: Array
```

Decorators: `@export`

Labels: { id:int, text:String, pos:Vector2, size:int, rot:float, z:int }.

### _px_per_m

```gdscript
var _px_per_m: float
```

### _pend_surfaces

```gdscript
var _pend_surfaces: Array
```

### _pend_lines

```gdscript
var _pend_lines: Array
```

### _pend_points

```gdscript
var _pend_points: Array
```

### _pend_labels

```gdscript
var _pend_labels: Array
```

## Signal Documentation

### elevation_changed

```gdscript
signal elevation_changed(rect: Rect2i)
```

Emits when the elevation image block changes.

### surfaces_changed

```gdscript
signal surfaces_changed(kind: String, ids: PackedInt32Array)
```

Emits when surfaces mutate. kind: "reset|added|removed|points|brush|meta".

### lines_changed

```gdscript
signal lines_changed(kind: String, ids: PackedInt32Array)
```

Emits when lines mutate. kind: "reset|added|removed|points|style|brush|meta".

### points_changed

```gdscript
signal points_changed(kind: String, ids: PackedInt32Array)
```

Emits when points mutate. kind: "reset|added|removed|move|style|meta".

### labels_changed

```gdscript
signal labels_changed(kind: String, ids: PackedInt32Array)
```

Emits when labels mutate. kind: "reset|added|removed|move|style|meta".
