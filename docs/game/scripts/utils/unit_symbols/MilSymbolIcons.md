# MilSymbolIcons Class Reference

*File:* `scripts/utils/unit_symbols/MilSymbolIcons.gd`
*Class name:* `MilSymbolIcons`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name MilSymbolIcons
extends RefCounted
```

## Brief

Icon definitions for military symbols
Provides simple icon shapes for different unit types

Get drawing instructions for `icon_type` and `affiliation`.

## Detailed Description

Coordinates use a 200x200 space.
[return] Dictionary with drawing commands; {} if missing.

## Public Member Functions

- [`func _get_icon_generators() -> Dictionary`](MilSymbolIcons/functions/_get_icon_generators.md) — Load and cache icon generators from ICONS_PATH.
- [`func parse_unit_type(unit_type: String) -> MilSymbol.UnitType`](MilSymbolIcons/functions/parse_unit_type.md) — Parse a simple unit type string to MilSymbol.UnitType

## Public Attributes

- `Variant inst`

## Member Function Documentation

### _get_icon_generators

```gdscript
func _get_icon_generators() -> Dictionary
```

Load and cache icon generators from ICONS_PATH.
Skips files with global class_names.
[return] Dictionary of generators keyed by MilSymbol.UnitType.

### parse_unit_type

```gdscript
func parse_unit_type(unit_type: String) -> MilSymbol.UnitType
```

Parse a simple unit type string to MilSymbol.UnitType

## Member Data Documentation

### inst

```gdscript
var inst: Variant
```
