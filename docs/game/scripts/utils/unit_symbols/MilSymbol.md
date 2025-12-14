# MilSymbol Class Reference

*File:* `scripts/utils/unit_symbols/MilSymbol.gd`
*Class name:* `MilSymbol`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name MilSymbol
extends RefCounted
```

## Brief

Main military symbol generator
Creates symbol textures using viewport rendering

Unit Type (Main Icon)

Unit Size/Echelon.

## Detailed Description

Generate a symbol texture using enums (primary API)
Returns an ImageTexture of the rendered symbol

Generate a symbol texture (internal - uses internal enum types)
Returns an ImageTexture of the rendered symbol

Generate a symbol texture from a simplified code
Code format: "AFFILIATION-DOMAIN-TYPE" (e.g., "F-G-INF" for Friend Ground Infantry)

Generate a symbol texture from unit data (same as generate() - kept for compatibility)
More convenient for game integration

Synchronously generate a symbol texture (blocking)
Use this carefully as it requires a SceneTree context

Static convenience method: create and generate in one call

Static convenience method for creating frame-only symbols (no fill)
One-liner for quick frame-only symbol generation

## Public Member Functions

- [`func _cache_put(key: String, tex: ImageTexture) -> void`](MilSymbol/functions/_cache_put.md)
- [`func _init(p_config: MilSymbolConfig = null) -> void`](MilSymbol/functions/_init.md)
- [`func cleanup() -> void`](MilSymbol/functions/cleanup.md) — Clean up resources
- [`func _ensure_viewport() -> void`](MilSymbol/functions/_ensure_viewport.md) — Ensure viewport and renderer exist
- [`func _parse_affiliation(code: String) -> UnitAffiliation`](MilSymbol/functions/_parse_affiliation.md) — Parse affiliation from string
- [`func _parse_icon_type(code: String) -> UnitType`](MilSymbol/functions/_parse_icon_type.md) — Parse icon type from string
- [`func _parse_domain(code: String) -> MilSymbolGeometry.Domain`](MilSymbol/functions/_parse_domain.md) — Parse domain from string
- [`func _unit_size_to_text(unit_size: UnitSize) -> String`](MilSymbol/functions/_unit_size_to_text.md) — Convert UnitSize enum to NATO size indicator text

## Public Attributes

- `MilSymbolConfig config` — Configuration
- `SubViewport _viewport` — Cached viewport and renderer (reused for efficiency)
- `MilSymbolRenderer _renderer`
- `Color frame_col`
- `Color fill_col`
- `Array key_data`
- `Variant cached`

## Public Constants

- `const _CACHE_MAX_ENTRIES: int` — Texture cache (avoid repeated viewport renders + GPU readbacks).

## Enumerations

- `enum UnitAffiliation` — Unit affiliation.
- `enum Modifier1` — Unit Modifier (top)
- `enum Modifier2` — Unit Modifier (bottom)
- `enum UnitStatus` — Unit Status
- `enum UnitReinforcedReduced` — Unit Reinforced or Reduced

## Member Function Documentation

### _cache_put

```gdscript
func _cache_put(key: String, tex: ImageTexture) -> void
```

### _init

```gdscript
func _init(p_config: MilSymbolConfig = null) -> void
```

### cleanup

```gdscript
func cleanup() -> void
```

Clean up resources

### _ensure_viewport

```gdscript
func _ensure_viewport() -> void
```

Ensure viewport and renderer exist

### _parse_affiliation

```gdscript
func _parse_affiliation(code: String) -> UnitAffiliation
```

Parse affiliation from string

### _parse_icon_type

```gdscript
func _parse_icon_type(code: String) -> UnitType
```

Parse icon type from string

### _parse_domain

```gdscript
func _parse_domain(code: String) -> MilSymbolGeometry.Domain
```

Parse domain from string

### _unit_size_to_text

```gdscript
func _unit_size_to_text(unit_size: UnitSize) -> String
```

Convert UnitSize enum to NATO size indicator text

## Member Data Documentation

### config

```gdscript
var config: MilSymbolConfig
```

Configuration

### _viewport

```gdscript
var _viewport: SubViewport
```

Cached viewport and renderer (reused for efficiency)

### _renderer

```gdscript
var _renderer: MilSymbolRenderer
```

### frame_col

```gdscript
var frame_col: Color
```

### fill_col

```gdscript
var fill_col: Color
```

### key_data

```gdscript
var key_data: Array
```

### cached

```gdscript
var cached: Variant
```

## Constant Documentation

### _CACHE_MAX_ENTRIES

```gdscript
const _CACHE_MAX_ENTRIES: int
```

Texture cache (avoid repeated viewport renders + GPU readbacks).

## Enumeration Type Documentation

### UnitAffiliation

```gdscript
enum UnitAffiliation
```

Unit affiliation.

### Modifier1

```gdscript
enum Modifier1
```

Unit Modifier (top)

### Modifier2

```gdscript
enum Modifier2
```

Unit Modifier (bottom)

### UnitStatus

```gdscript
enum UnitStatus
```

Unit Status

### UnitReinforcedReduced

```gdscript
enum UnitReinforcedReduced
```

Unit Reinforced or Reduced
