# TerrainBrush Class Reference

*File:* `scripts/terrain/TerrainBrush.gd`
*Class name:* `TerrainBrush`
*Inherits:* `Resource`
> **Experimental**

## Synopsis

```gdscript
class_name TerrainBrush
extends Resource
```

## Brief

Defines how a terrain feature is drawn on the tactical map and how it
influences simulation (movement, LOS, combat).

## Detailed Description

Designers create .tres instances for roads, rivers, forests, urban, etc.

## Public Member Functions

- [`func movement_multiplier(profile: int) -> float`](TerrainBrush/functions/movement_multiplier.md) — Returns the movement multiplier for a given profile.
- [`func los_attenuation_for_length(length_m: float) -> float`](TerrainBrush/functions/los_attenuation_for_length.md) — Returns cumulative LOS attenuation for a ray marching `length_m`.
- [`func defensive_modifiers() -> Dictionary`](TerrainBrush/functions/defensive_modifiers.md) — Returns a simple defensive modifier bundle for Combat.gd.
- [`func get_draw_recipe() -> Dictionary`](TerrainBrush/functions/get_draw_recipe.md) — Provide a light-weight draw recipe for the renderer.

## Public Attributes

- `String legend_title` — Legend Title
- `FeatureType feature_type` — The geometry type of the feature (line, polygon, or point).
- `DrawMode draw_mode` — Drawing style used for rendering the feature.
- `int z_index` — Rendering order relative to other features.
- `Color stroke_color` — Outline color of the feature.
- `float stroke_width_px` — Outline width in pixels.
- `float dash_px` — Dash length in pixels (when dashed mode is used).
- `float gap_px` — Gap length between dashes (when dashed mode is used).
- `Color fill_color` — Fill color of polygons.
- `float hatch_spacing_px` — Spacing of hatch lines in pixels.
- `float hatch_angle_deg` — Angle of hatch lines in degrees.
- `Texture2D symbol` — Symbol texture for tiled rendering.
- `float symbol_spacing_px` — Spacing between repeated symbols in pixels.
- `float symbol_size_m` — Symbol size in meters
- `SymbolAlign symbol_align` — Alignment of symbols relative to geometry.
- `float mv_tracked` — Movement multiplier for tracked vehicles.
- `float mv_wheeled` — Movement multiplier for wheeled vehicles.
- `float mv_foot` — Movement multiplier for foot infantry.
- `float mv_riverine` — Movement multiplier for riverine units.
- `float los_attenuation_per_m` — Linear attenuation per meter traversed “through” the feature (0..1).
- `float spotting_penalty_m` — Additive penalty to initial detection (meters).
- `float cover_reduction` — Percentage reduction to incoming attack power (0..1).
- `float concealment` — Percentage reduction to chance of being spotted (0..1).
- `float road_bias` — (Roads) Preferred multiplier for routing heuristic (<1 = preferred).
- `float bridge_capacity_tons` — (Bridges) Max mass in tons that can traverse; 0 = unlimited/not a bridge.

## Enumerations

- `enum FeatureType` — Type of feature geometry.
- `enum DrawMode` — Rendering mode for the feature.
- `enum SymbolAlign` — Orientation of tiled symbols.
- `enum MoveProfile` — Movement profile of a unit type.

## Member Function Documentation

### movement_multiplier

```gdscript
func movement_multiplier(profile: int) -> float
```

Returns the movement multiplier for a given profile.

### los_attenuation_for_length

```gdscript
func los_attenuation_for_length(length_m: float) -> float
```

Returns cumulative LOS attenuation for a ray marching `length_m`.

### defensive_modifiers

```gdscript
func defensive_modifiers() -> Dictionary
```

Returns a simple defensive modifier bundle for Combat.gd.

### get_draw_recipe

```gdscript
func get_draw_recipe() -> Dictionary
```

Provide a light-weight draw recipe for the renderer.

## Member Data Documentation

### legend_title

```gdscript
var legend_title: String
```

Decorators: `@export`

Legend Title

### feature_type

```gdscript
var feature_type: FeatureType
```

Decorators: `@export`

The geometry type of the feature (line, polygon, or point).

### draw_mode

```gdscript
var draw_mode: DrawMode
```

Decorators: `@export`

Drawing style used for rendering the feature.

### z_index

```gdscript
var z_index: int
```

Decorators: `@export`

Rendering order relative to other features.

### stroke_color

```gdscript
var stroke_color: Color
```

Decorators: `@export`

Outline color of the feature.

### stroke_width_px

```gdscript
var stroke_width_px: float
```

Decorators: `@export_range(0.5, 12.0, 0.5)`

Outline width in pixels.

### dash_px

```gdscript
var dash_px: float
```

Decorators: `@export`

Dash length in pixels (when dashed mode is used).

### gap_px

```gdscript
var gap_px: float
```

Decorators: `@export`

Gap length between dashes (when dashed mode is used).

### fill_color

```gdscript
var fill_color: Color
```

Decorators: `@export`

Fill color of polygons.

### hatch_spacing_px

```gdscript
var hatch_spacing_px: float
```

Decorators: `@export`

Spacing of hatch lines in pixels.

### hatch_angle_deg

```gdscript
var hatch_angle_deg: float
```

Decorators: `@export`

Angle of hatch lines in degrees.

### symbol

```gdscript
var symbol: Texture2D
```

Decorators: `@export`

Symbol texture for tiled rendering.

### symbol_spacing_px

```gdscript
var symbol_spacing_px: float
```

Decorators: `@export`

Spacing between repeated symbols in pixels.

### symbol_size_m

```gdscript
var symbol_size_m: float
```

Decorators: `@export`

Symbol size in meters

### symbol_align

```gdscript
var symbol_align: SymbolAlign
```

Decorators: `@export`

Alignment of symbols relative to geometry.

### mv_tracked

```gdscript
var mv_tracked: float
```

Decorators: `@export`

Movement multiplier for tracked vehicles.

### mv_wheeled

```gdscript
var mv_wheeled: float
```

Decorators: `@export`

Movement multiplier for wheeled vehicles.

### mv_foot

```gdscript
var mv_foot: float
```

Decorators: `@export`

Movement multiplier for foot infantry.

### mv_riverine

```gdscript
var mv_riverine: float
```

Decorators: `@export`

Movement multiplier for riverine units.

### los_attenuation_per_m

```gdscript
var los_attenuation_per_m: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Linear attenuation per meter traversed “through” the feature (0..1).

### spotting_penalty_m

```gdscript
var spotting_penalty_m: float
```

Decorators: `@export`

Additive penalty to initial detection (meters).

### cover_reduction

```gdscript
var cover_reduction: float
```

Decorators: `@export_range(0.0, 1.0, 0.05)`

Percentage reduction to incoming attack power (0..1).

### concealment

```gdscript
var concealment: float
```

Decorators: `@export_range(0.0, 1.0, 0.05)`

Percentage reduction to chance of being spotted (0..1).

### road_bias

```gdscript
var road_bias: float
```

Decorators: `@export`

(Roads) Preferred multiplier for routing heuristic (<1 = preferred).

### bridge_capacity_tons

```gdscript
var bridge_capacity_tons: float
```

Decorators: `@export`

(Bridges) Max mass in tons that can traverse; 0 = unlimited/not a bridge.

## Enumeration Type Documentation

### FeatureType

```gdscript
enum FeatureType
```

Type of feature geometry.

### DrawMode

```gdscript
enum DrawMode
```

Rendering mode for the feature.

### SymbolAlign

```gdscript
enum SymbolAlign
```

Orientation of tiled symbols.

### MoveProfile

```gdscript
enum MoveProfile
```

Movement profile of a unit type.
