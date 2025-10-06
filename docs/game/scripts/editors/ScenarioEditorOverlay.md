# ScenarioEditorOverlay Class Reference

*File:* `scripts/editors/ScenarioEditorOverlay.gd`
*Class name:* `ScenarioEditorOverlay`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name ScenarioEditorOverlay
extends Control
```

## Brief

Draws editor overlays: placed units, selection, and active tool ghosts.

## Detailed Description

The TerrainRender handles map<->terrain transforms; this node just draws.

Context menu id: open slot configuration

Context menu id: open unit configuration

Context menu id: open task configuration

Context menu id: open trigger configuration

Context menu id: delete picked entity

Owning editor reference (provides ctx, data, and services)

## Public Member Functions

- [`func _ready() -> void`](ScenarioEditorOverlay/functions/_ready.md) — Initialize popup menu and mouse handling
- [`func _draw() -> void`](ScenarioEditorOverlay/functions/_draw.md) — Main overlay draw: links first, then glyphs, then active tool
- [`func request_redraw() -> void`](ScenarioEditorOverlay/functions/request_redraw.md) — Request a redraw of the overlay
- [`func set_selected(pick: Dictionary) -> void`](ScenarioEditorOverlay/functions/set_selected.md) — Set current selection highlight
- [`func clear_selected() -> void`](ScenarioEditorOverlay/functions/clear_selected.md) — Clear current selection highlight
- [`func get_pick_at(pos: Vector2) -> Dictionary`](ScenarioEditorOverlay/functions/get_pick_at.md) — Return the closest pickable entity under the given screen position
- [`func on_ctx_open(event: InputEventMouseButton)`](ScenarioEditorOverlay/functions/on_ctx_open.md) — Open context menu at mouse position using current pick
- [`func on_dbl_click(event: InputEventMouseButton)`](ScenarioEditorOverlay/functions/on_dbl_click.md) — Handle double-click on a glyph (open config)
- [`func on_mouse_move(pos: Vector2) -> void`](ScenarioEditorOverlay/functions/on_mouse_move.md) — Update hover state and schedule redraw
- [`func _on_ctx_pressed(id: int) -> void`](ScenarioEditorOverlay/functions/_on_ctx_pressed.md) — Handle context menu actions for the last pick
- [`func _draw_units() -> void`](ScenarioEditorOverlay/functions/_draw_units.md) — Draw all unit glyphs and hover titles
- [`func _draw_slots() -> void`](ScenarioEditorOverlay/functions/_draw_slots.md) — Draw all player slot glyphs and hover titles
- [`func _draw_tasks() -> void`](ScenarioEditorOverlay/functions/_draw_tasks.md) — Draw all task glyphs and hover titles
- [`func _draw_task_links() -> void`](ScenarioEditorOverlay/functions/_draw_task_links.md) — Draw task chain arrows between unit/task and next task
- [`func _draw_triggers() -> void`](ScenarioEditorOverlay/functions/_draw_triggers.md) — Draw trigger areas (circle/rect), outlines, and optional icon/title
- [`func _draw_trigger_shape(trig: ScenarioTrigger, center_px: Vector2, hi: bool) -> void`](ScenarioEditorOverlay/functions/_draw_trigger_shape.md) — Draw a single trigger's shape + icon with hover colors
- [`func _draw_sync_links() -> void`](ScenarioEditorOverlay/functions/_draw_sync_links.md) — Draw all synchronization lines from triggers to units/tasks
- [`func begin_link_preview(src_pick: Dictionary) -> void`](ScenarioEditorOverlay/functions/begin_link_preview.md) — Begin live link line preview from a source pick
- [`func update_link_preview(mouse_pos: Vector2) -> void`](ScenarioEditorOverlay/functions/update_link_preview.md) — Update live link preview endpoint (mouse)
- [`func end_link_preview() -> void`](ScenarioEditorOverlay/functions/end_link_preview.md) — End live link preview and clear state
- [`func _screen_pos_for_pick(pick: Dictionary) -> Vector2`](ScenarioEditorOverlay/functions/_screen_pos_for_pick.md) — Return on-screen center of a given pick (fallback to hover pos)
- [`func _is_highlighted(t: StringName, idx: int) -> bool`](ScenarioEditorOverlay/functions/_is_highlighted.md) — Check if a glyph of type/index is hovered or selected
- [`func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void`](ScenarioEditorOverlay/functions/_draw_icon_with_hover.md) — Draw a texture centered, with hover scale/opacity feedback
- [`func _draw_title(text: String, center: Vector2) -> void`](ScenarioEditorOverlay/functions/_draw_title.md) — Draw a small label next to a glyph
- [`func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void`](ScenarioEditorOverlay/functions/_draw_task_glyph.md) — Delegate task glyph drawing to the task resource
- [`func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void`](ScenarioEditorOverlay/functions/_draw_arrow.md) — Draw an arrow line with two head strokes
- [`func _pick_at(overlay_pos: Vector2) -> Dictionary`](ScenarioEditorOverlay/functions/_pick_at.md) — Hit-test the closest entity under the overlay position
- [`func _slot_pos_m(entry) -> Vector2`](ScenarioEditorOverlay/functions/_slot_pos_m.md) — Extract slot world position from either dict or resource
- [`func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D`](ScenarioEditorOverlay/functions/_get_scaled_icon_unit.md) — Get (and cache) a scaled unit icon respecting affiliation
- [`func _get_scaled_icon_slot() -> Texture2D`](ScenarioEditorOverlay/functions/_get_scaled_icon_slot.md) — Get (and cache) the scaled slot icon
- [`func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D`](ScenarioEditorOverlay/functions/_get_scaled_icon_task.md) — Get (and cache) the scaled inner task icon
- [`func _get_scaled_icon_trigger(trig: ScenarioTrigger) -> Texture2D`](ScenarioEditorOverlay/functions/_get_scaled_icon_trigger.md) — Get (and cache) the scaled trigger center icon
- [`func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D`](ScenarioEditorOverlay/functions/_scale_icon.md) — Utility used by task glyphs to request scaled textures
- [`func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D`](ScenarioEditorOverlay/functions/_scaled_cached.md) — Scale and cache a texture by key and target pixel size
- [`func _glyph_radius(kind: StringName, idx: int) -> float`](ScenarioEditorOverlay/functions/_glyph_radius.md) — Return approximate visual radius for a glyph kind/index
- [`func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]`](ScenarioEditorOverlay/functions/_trim_segment.md) — Shorten a segment at both ends by given trims (pixels)

## Public Attributes

- `ScenarioEditor editor`
- `int unit_icon_px` — Pixel size of unit icons on the overlay
- `int slot_icon_px` — Pixel size of player slot icons on the overlay
- `int task_icon_px` — Pixel size of outer task glyphs on the overlay
- `int task_icon_inner_px` — Pixel size of inner task glyph icons
- `int trigger_icon_px` — Pixel size of trigger center icon
- `Color trigger_fill` — Trigger area fill color (semi-transparent)
- `Color trigger_outline` — Trigger area outline color
- `Color sync_line_color` — Color for synchronization link lines
- `float sync_line_width` — Width in pixels for synchronization link lines
- `Texture2D slot_icon` — Texture used for slot icons
- `float hover_scale` — Scale multiplier for hovered glyphs
- `Vector2 hover_title_offset` — Screen-space offset for hover title labels
- `float link_gap_px` — Extra pixel gap between link line and glyph edge
- `float arrow_head_len_px` — Arrow head length (pixels) for link arrows
- `PopupMenu _ctx`
- `Dictionary _last_pick`
- `Dictionary _selected_pick`
- `Dictionary _hover_pick`
- `Vector2 _hover_pos`
- `Dictionary _link_preview_src`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize popup menu and mouse handling

### _draw

```gdscript
func _draw() -> void
```

Main overlay draw: links first, then glyphs, then active tool

### request_redraw

```gdscript
func request_redraw() -> void
```

Request a redraw of the overlay

### set_selected

```gdscript
func set_selected(pick: Dictionary) -> void
```

Set current selection highlight

### clear_selected

```gdscript
func clear_selected() -> void
```

Clear current selection highlight

### get_pick_at

```gdscript
func get_pick_at(pos: Vector2) -> Dictionary
```

Return the closest pickable entity under the given screen position

### on_ctx_open

```gdscript
func on_ctx_open(event: InputEventMouseButton)
```

Open context menu at mouse position using current pick

### on_dbl_click

```gdscript
func on_dbl_click(event: InputEventMouseButton)
```

Handle double-click on a glyph (open config)

### on_mouse_move

```gdscript
func on_mouse_move(pos: Vector2) -> void
```

Update hover state and schedule redraw

### _on_ctx_pressed

```gdscript
func _on_ctx_pressed(id: int) -> void
```

Handle context menu actions for the last pick

### _draw_units

```gdscript
func _draw_units() -> void
```

Draw all unit glyphs and hover titles

### _draw_slots

```gdscript
func _draw_slots() -> void
```

Draw all player slot glyphs and hover titles

### _draw_tasks

```gdscript
func _draw_tasks() -> void
```

Draw all task glyphs and hover titles

### _draw_task_links

```gdscript
func _draw_task_links() -> void
```

Draw task chain arrows between unit/task and next task

### _draw_triggers

```gdscript
func _draw_triggers() -> void
```

Draw trigger areas (circle/rect), outlines, and optional icon/title

### _draw_trigger_shape

```gdscript
func _draw_trigger_shape(trig: ScenarioTrigger, center_px: Vector2, hi: bool) -> void
```

Draw a single trigger's shape + icon with hover colors

### _draw_sync_links

```gdscript
func _draw_sync_links() -> void
```

Draw all synchronization lines from triggers to units/tasks

### begin_link_preview

```gdscript
func begin_link_preview(src_pick: Dictionary) -> void
```

Begin live link line preview from a source pick

### update_link_preview

```gdscript
func update_link_preview(mouse_pos: Vector2) -> void
```

Update live link preview endpoint (mouse)

### end_link_preview

```gdscript
func end_link_preview() -> void
```

End live link preview and clear state

### _screen_pos_for_pick

```gdscript
func _screen_pos_for_pick(pick: Dictionary) -> Vector2
```

Return on-screen center of a given pick (fallback to hover pos)

### _is_highlighted

```gdscript
func _is_highlighted(t: StringName, idx: int) -> bool
```

Check if a glyph of type/index is hovered or selected

### _draw_icon_with_hover

```gdscript
func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void
```

Draw a texture centered, with hover scale/opacity feedback

### _draw_title

```gdscript
func _draw_title(text: String, center: Vector2) -> void
```

Draw a small label next to a glyph

### _draw_task_glyph

```gdscript
func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void
```

Delegate task glyph drawing to the task resource

### _draw_arrow

```gdscript
func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void
```

Draw an arrow line with two head strokes

### _pick_at

```gdscript
func _pick_at(overlay_pos: Vector2) -> Dictionary
```

Hit-test the closest entity under the overlay position

### _slot_pos_m

```gdscript
func _slot_pos_m(entry) -> Vector2
```

Extract slot world position from either dict or resource

### _get_scaled_icon_unit

```gdscript
func _get_scaled_icon_unit(u: ScenarioUnit) -> Texture2D
```

Get (and cache) a scaled unit icon respecting affiliation

### _get_scaled_icon_slot

```gdscript
func _get_scaled_icon_slot() -> Texture2D
```

Get (and cache) the scaled slot icon

### _get_scaled_icon_task

```gdscript
func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D
```

Get (and cache) the scaled inner task icon

### _get_scaled_icon_trigger

```gdscript
func _get_scaled_icon_trigger(trig: ScenarioTrigger) -> Texture2D
```

Get (and cache) the scaled trigger center icon

### _scale_icon

```gdscript
func _scale_icon(tex: Texture2D, key: String, px: int) -> Texture2D
```

Utility used by task glyphs to request scaled textures

### _scaled_cached

```gdscript
func _scaled_cached(key: String, base: Texture2D, px: int) -> Texture2D
```

Scale and cache a texture by key and target pixel size

### _glyph_radius

```gdscript
func _glyph_radius(kind: StringName, idx: int) -> float
```

Return approximate visual radius for a glyph kind/index

### _trim_segment

```gdscript
func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]
```

Shorten a segment at both ends by given trims (pixels)

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### unit_icon_px

```gdscript
var unit_icon_px: int
```

Pixel size of unit icons on the overlay

### slot_icon_px

```gdscript
var slot_icon_px: int
```

Pixel size of player slot icons on the overlay

### task_icon_px

```gdscript
var task_icon_px: int
```

Pixel size of outer task glyphs on the overlay

### task_icon_inner_px

```gdscript
var task_icon_inner_px: int
```

Pixel size of inner task glyph icons

### trigger_icon_px

```gdscript
var trigger_icon_px: int
```

Pixel size of trigger center icon

### trigger_fill

```gdscript
var trigger_fill: Color
```

Trigger area fill color (semi-transparent)

### trigger_outline

```gdscript
var trigger_outline: Color
```

Trigger area outline color

### sync_line_color

```gdscript
var sync_line_color: Color
```

Color for synchronization link lines

### sync_line_width

```gdscript
var sync_line_width: float
```

Width in pixels for synchronization link lines

### slot_icon

```gdscript
var slot_icon: Texture2D
```

Texture used for slot icons

### hover_scale

```gdscript
var hover_scale: float
```

Scale multiplier for hovered glyphs

### hover_title_offset

```gdscript
var hover_title_offset: Vector2
```

Screen-space offset for hover title labels

### link_gap_px

```gdscript
var link_gap_px: float
```

Extra pixel gap between link line and glyph edge

### arrow_head_len_px

```gdscript
var arrow_head_len_px: float
```

Arrow head length (pixels) for link arrows

### _ctx

```gdscript
var _ctx: PopupMenu
```

### _last_pick

```gdscript
var _last_pick: Dictionary
```

### _selected_pick

```gdscript
var _selected_pick: Dictionary
```

### _hover_pick

```gdscript
var _hover_pick: Dictionary
```

### _hover_pos

```gdscript
var _hover_pos: Vector2
```

### _link_preview_src

```gdscript
var _link_preview_src: Dictionary
```
