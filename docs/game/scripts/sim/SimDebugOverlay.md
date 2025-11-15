# SimDebugOverlay Class Reference

*File:* `scripts/sim/SimDebugOverlay.gd`
*Class name:* `SimDebugOverlay`
*Inherits:* `Control`
> **Experimental**

## Synopsis

```gdscript
class_name SimDebugOverlay
extends Control
```

## Brief

Simulation debug overlay drawn on top of TerrainRender.

## Detailed Description

Renders unit icons, paths, destinations, labels (order/behaviour/
combat mode), strength/morale/fuel bars, and recent combat highlights.
Attach as a child of `TerrainRender` so drawing aligns with the map.

Show unit icons.

Show planned movement paths.

Show unit destination rings.

Show text labels (callsign/order/behaviour/combat/ratios).

Include last applied order in labels.

Show strength/morale (and fuel) bars under icons.

Highlight units recently in contact.

Show fuel percentage (when available).

Draw red lines between engaged pairs.

Icon size in pixels (square).

Path stroke width in pixels.

Destination ring radius in pixels.

Label font size (pixels).

Label offset from icon center (pixels).

Combat line stroke width (pixels).

Alpha for dead units' icons.

## Public Member Functions

- [`func _ready() -> void`](SimDebugOverlay/functions/_ready.md) — Auto-wire references, build caches, connect signals, and set processing.
- [`func _process(_dt: float) -> void`](SimDebugOverlay/functions/_process.md) — Fade recent-combat markers and request redraws while enabled.
- [`func _on_resized() -> void`](SimDebugOverlay/functions/_on_resized.md) — Recompute transforms when map or base resizes.
- [`func _compute_map_transform() -> void`](SimDebugOverlay/functions/_compute_map_transform.md) — Compute the Base -> Overlay transform so overlay drawing aligns with the map.
- [`func _rebuild_id_index() -> void`](SimDebugOverlay/functions/_rebuild_id_index.md) — Build unit_id -> ScenarioUnit lookup from the current scenario.
- [`func _on_order_applied(order: Dictionary) -> void`](SimDebugOverlay/functions/_on_order_applied.md) — Record the last applied order per unit for label display.
- [`func _on_order_failed(order: Dictionary, _reason: String) -> void`](SimDebugOverlay/functions/_on_order_failed.md) — Record failed order attempts (marked ✖) to aid debugging.
- [`func _on_contact(attacker_id: String, defender_id: String, _damage: float = 0.0) -> void`](SimDebugOverlay/functions/_on_contact.md) — Mark attacker/defender as “hot” for a short period after combat.
- [`func _on_state(_prev, _next) -> void`](SimDebugOverlay/functions/_on_state.md) — Request redraw when mission state changes (e.g.
- [`func _on_unit_updated(_id: String, _snap: Dictionary) -> void`](SimDebugOverlay/functions/_on_unit_updated.md) — Request redraw when a unit snapshot updates.
- [`func _draw() -> void`](SimDebugOverlay/functions/_draw.md) — Draw icons, paths, destinations, labels, and bars for all units.
- [`func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void`](SimDebugOverlay/functions/_draw_bar.md) — Draw a ratio bar with background and thin border.
- [`func _norm_ratio(v: float, t: float = 100.0) -> float`](SimDebugOverlay/functions/_norm_ratio.md) — Normalize values; treat values >1 as percentages using `t` as max.
- [`func _enum_name(_enum: Variant, value: int) -> String`](SimDebugOverlay/functions/_enum_name.md) — Convert enum value to a short human label.
- [`func _state_name(s: int) -> String`](SimDebugOverlay/functions/_state_name.md) — Convert ScenarioUnit.MoveState to a compact label.

## Public Attributes

- `bool: debug_enabled` — Master toggle; when false the overlay does not process or draw.
- `TerrainRender terrain_renderer` — Terrain renderer used for map/terrain coordinate transforms.
- `SimWorld _sim` — Simulation world for unit snapshots and mission timing.
- `OrdersRouter _orders` — Orders router to show last applied order per unit.
- `FuelSystem _fuel` — Fuel system to display fuel state bars.
- `Color friend_color` — Friendly color.
- `Color enemy_color` — Enemy color.
- `Color text_color` — Label text color.
- `Color hot_color` — “Hot” label color for recent combat.
- `Color bar_bg` — Bar background color.
- `Color bar_strength` — Strength bar color.
- `Color bar_morale` — Morale bar color.
- `Color bar_fuel` — Fuel bar color.
- `Color combat_line_color` — Combat line color.
- `Control _terrain_base`
- `Transform2D _map_tf`
- `Rect2 _map_rect`
- `Dictionary _unit_by_id`
- `Dictionary _last_order`
- `Dictionary _recent_contact_until`
- `bool _debug_enabled`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Auto-wire references, build caches, connect signals, and set processing.

### _process

```gdscript
func _process(_dt: float) -> void
```

Fade recent-combat markers and request redraws while enabled.
`_dt` Delta time (seconds).

### _on_resized

```gdscript
func _on_resized() -> void
```

Recompute transforms when map or base resizes.

### _compute_map_transform

```gdscript
func _compute_map_transform() -> void
```

Compute the Base -> Overlay transform so overlay drawing aligns with the map.

### _rebuild_id_index

```gdscript
func _rebuild_id_index() -> void
```

Build unit_id -> ScenarioUnit lookup from the current scenario.

### _on_order_applied

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

Record the last applied order per unit for label display.
`order` Order dictionary that was applied.

### _on_order_failed

```gdscript
func _on_order_failed(order: Dictionary, _reason: String) -> void
```

Record failed order attempts (marked ✖) to aid debugging.
`order` Order dictionary that failed.
`_reason` Failure reason (unused here).

### _on_contact

```gdscript
func _on_contact(attacker_id: String, defender_id: String, _damage: float = 0.0) -> void
```

Mark attacker/defender as “hot” for a short period after combat.
`attacker_id` Attacker unit id.
`defender_id` Defender unit id.

### _on_state

```gdscript
func _on_state(_prev, _next) -> void
```

Request redraw when mission state changes (e.g. RUNNING/PAUSED).

### _on_unit_updated

```gdscript
func _on_unit_updated(_id: String, _snap: Dictionary) -> void
```

Request redraw when a unit snapshot updates.

### _draw

```gdscript
func _draw() -> void
```

Draw icons, paths, destinations, labels, and bars for all units.

### _draw_bar

```gdscript
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void
```

Draw a ratio bar with background and thin border.
`tl` Top-left in overlay pixels.
`w` Width (px).
`h` Height (px).
`ratio` Fill ratio [0..1].
`col` Fill color.

### _norm_ratio

```gdscript
func _norm_ratio(v: float, t: float = 100.0) -> float
```

Normalize values; treat values >1 as percentages using `t` as max.
`v` Input value (0..1 or 0..t).
`t` Maximum when v is in “percent-like” scale (default 100).
[return] Ratio clamped to [0, 1].

### _enum_name

```gdscript
func _enum_name(_enum: Variant, value: int) -> String
```

Convert enum value to a short human label.
`_enum` Enum type marker.
`value` Enum value.
[return] Short label string.

### _state_name

```gdscript
func _state_name(s: int) -> String
```

Convert ScenarioUnit.MoveState to a compact label.
`s` MoveState enum value.
[return] Short label string.

## Member Data Documentation

### debug_enabled

```gdscript
var debug_enabled: bool:
```

Decorators: `@export`

Master toggle; when false the overlay does not process or draw.

### terrain_renderer

```gdscript
var terrain_renderer: TerrainRender
```

Decorators: `@export`

Terrain renderer used for map/terrain coordinate transforms.

### _sim

```gdscript
var _sim: SimWorld
```

Decorators: `@export`

Simulation world for unit snapshots and mission timing.

### _orders

```gdscript
var _orders: OrdersRouter
```

Decorators: `@export`

Orders router to show last applied order per unit.

### _fuel

```gdscript
var _fuel: FuelSystem
```

Decorators: `@export`

Fuel system to display fuel state bars.

### friend_color

```gdscript
var friend_color: Color
```

Decorators: `@export`

Friendly color.

### enemy_color

```gdscript
var enemy_color: Color
```

Decorators: `@export`

Enemy color.

### text_color

```gdscript
var text_color: Color
```

Decorators: `@export`

Label text color.

### hot_color

```gdscript
var hot_color: Color
```

Decorators: `@export`

“Hot” label color for recent combat.

### bar_bg

```gdscript
var bar_bg: Color
```

Decorators: `@export`

Bar background color.

### bar_strength

```gdscript
var bar_strength: Color
```

Decorators: `@export`

Strength bar color.

### bar_morale

```gdscript
var bar_morale: Color
```

Decorators: `@export`

Morale bar color.

### bar_fuel

```gdscript
var bar_fuel: Color
```

Decorators: `@export`

Fuel bar color.

### combat_line_color

```gdscript
var combat_line_color: Color
```

Decorators: `@export`

Combat line color.

### _terrain_base

```gdscript
var _terrain_base: Control
```

### _map_tf

```gdscript
var _map_tf: Transform2D
```

### _map_rect

```gdscript
var _map_rect: Rect2
```

### _unit_by_id

```gdscript
var _unit_by_id: Dictionary
```

### _last_order

```gdscript
var _last_order: Dictionary
```

### _recent_contact_until

```gdscript
var _recent_contact_until: Dictionary
```

### _debug_enabled

```gdscript
var _debug_enabled: bool
```
