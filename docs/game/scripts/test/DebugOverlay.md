# DebugOverlay Class Reference

*File:* `scripts/test/DebugOverlay.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Public Member Functions

- [`func setup_overlay(renderer: TerrainRender, units: Array) -> void`](DebugOverlay/functions/setup_overlay.md)
- [`func update_debug(d: Dictionary) -> void`](DebugOverlay/functions/update_debug.md)
- [`func _draw() -> void`](DebugOverlay/functions/_draw.md)
- [`func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void`](DebugOverlay/functions/_draw_unit_glyphs.md)
- [`func _icon_for_unit(su: ScenarioUnit) -> Texture2D`](DebugOverlay/functions/_icon_for_unit.md)
- [`func _draw_text_panel(d: Dictionary) -> void`](DebugOverlay/functions/_draw_text_panel.md)
- [`func _screen_from_m(pos_m: Vector2) -> Vector2`](DebugOverlay/functions/_screen_from_m.md)

## Public Attributes

- `TerrainRender _renderer`
- `Array _units`
- `Dictionary _dbg`

## Member Function Documentation

### setup_overlay

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void
```

### update_debug

```gdscript
func update_debug(d: Dictionary) -> void
```

### _draw

```gdscript
func _draw() -> void
```

### _draw_unit_glyphs

```gdscript
func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void
```

### _icon_for_unit

```gdscript
func _icon_for_unit(su: ScenarioUnit) -> Texture2D
```

### _draw_text_panel

```gdscript
func _draw_text_panel(d: Dictionary) -> void
```

### _screen_from_m

```gdscript
func _screen_from_m(pos_m: Vector2) -> Vector2
```

## Member Data Documentation

### _renderer

```gdscript
var _renderer: TerrainRender
```

### _units

```gdscript
var _units: Array
```

### _dbg

```gdscript
var _dbg: Dictionary
```
