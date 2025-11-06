# MilSymbolConfig Class Reference

*File:* `scripts/utils/unit_symbols/MilSymbolConfig.gd`
*Class name:* `MilSymbolConfig`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name MilSymbolConfig
extends Resource
```

## Brief

Configuration resource for military symbols

## Detailed Description

Defines colors, sizes, and style settings for symbol generation

## Public Member Functions

- [`func get_pixel_size() -> int`](MilSymbolConfig/functions/get_pixel_size.md) — Get the actual pixel size for this configuration
- [`func get_fill_color(affiliation: MilSymbol.UnitAffiliation) -> Color`](MilSymbolConfig/functions/get_fill_color.md) — Get fill color for MilSymbol.UnitAffiliation
- [`func get_frame_color(affiliation: MilSymbol.UnitAffiliation) -> Color`](MilSymbolConfig/functions/get_frame_color.md) — Get frame color for MilSymbol.UnitAffiliation
- [`func create_default() -> MilSymbolConfig`](MilSymbolConfig/functions/create_default.md) — Create a default configuration
- [`func create_frame_only() -> MilSymbolConfig`](MilSymbolConfig/functions/create_frame_only.md) — Create a configuration for frame-only symbols (no fill)
- [`func get_frame_colors() -> Dictionary`](MilSymbolConfig/functions/get_frame_colors.md)
- [`func get_fill_colors() -> Dictionary`](MilSymbolConfig/functions/get_fill_colors.md)

## Public Attributes

- `Size size` — Symbol size in pixels
- `float resolution_scale` — Resolution multiplier for anti-aliasing
- `float stroke_width` — Stroke width for frame outlines
- `bool filled` — Whether to fill the frame with color
- `float fill_opacity` — Fill opacity (0.0 - 1.0)
- `bool framed` — Whether to draw the frame
- `bool show_icon` — Whether to draw icons
- `int font_size` — Font for text fields
- `Dictionary fill_colors` — Colors for different affiliations (filled mode)
- `Dictionary frame_colors` — Colors for frame outlines
- `Color icon_color` — Color for icons
- `Color text_color` — Color for text labels

## Public Constants

- `const BASE_SIZE: float` — Base size for drawing coordinates (symbols are drawn in a 200x200 space)

## Enumerations

- `enum Size` — Size categories for symbols

## Member Function Documentation

### get_pixel_size

```gdscript
func get_pixel_size() -> int
```

Get the actual pixel size for this configuration

### get_fill_color

```gdscript
func get_fill_color(affiliation: MilSymbol.UnitAffiliation) -> Color
```

Get fill color for MilSymbol.UnitAffiliation

### get_frame_color

```gdscript
func get_frame_color(affiliation: MilSymbol.UnitAffiliation) -> Color
```

Get frame color for MilSymbol.UnitAffiliation

### create_default

```gdscript
func create_default() -> MilSymbolConfig
```

Create a default configuration

### create_frame_only

```gdscript
func create_frame_only() -> MilSymbolConfig
```

Create a configuration for frame-only symbols (no fill)
Useful for outline-style unit symbols
Uses white lines for easy color modulation

### get_frame_colors

```gdscript
func get_frame_colors() -> Dictionary
```

### get_fill_colors

```gdscript
func get_fill_colors() -> Dictionary
```

## Member Data Documentation

### size

```gdscript
var size: Size
```

Decorators: `@export`

Symbol size in pixels

### resolution_scale

```gdscript
var resolution_scale: float
```

Decorators: `@export`

Resolution multiplier for anti-aliasing
Higher values = smoother lines but larger texture memory
1 = native resolution, 2 = 2x resolution (recommended), 4 = 4x resolution

### stroke_width

```gdscript
var stroke_width: float
```

Decorators: `@export`

Stroke width for frame outlines

### filled

```gdscript
var filled: bool
```

Decorators: `@export`

Whether to fill the frame with color

### fill_opacity

```gdscript
var fill_opacity: float
```

Decorators: `@export`

Fill opacity (0.0 - 1.0)

### framed

```gdscript
var framed: bool
```

Decorators: `@export`

Whether to draw the frame

### show_icon

```gdscript
var show_icon: bool
```

Decorators: `@export`

Whether to draw icons

### font_size

```gdscript
var font_size: int
```

Font for text fields

### fill_colors

```gdscript
var fill_colors: Dictionary
```

Colors for different affiliations (filled mode)

### frame_colors

```gdscript
var frame_colors: Dictionary
```

Colors for frame outlines

### icon_color

```gdscript
var icon_color: Color
```

Color for icons

### text_color

```gdscript
var text_color: Color
```

Color for text labels

## Constant Documentation

### BASE_SIZE

```gdscript
const BASE_SIZE: float
```

Base size for drawing coordinates (symbols are drawn in a 200x200 space)

## Enumeration Type Documentation

### Size

```gdscript
enum Size
```

Size categories for symbols
