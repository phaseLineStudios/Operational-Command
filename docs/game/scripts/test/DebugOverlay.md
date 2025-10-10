# DebugOverlay Class Reference

*File:* `scripts/test/DebugOverlay.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Tactical debug overlay: icons, status bars, LOS line and a text panel.

## Detailed Description

Now also shows fuel levels and applied speed penalties via FuelSystem.

Toggles

Style

## Public Member Functions

- [`func setup_overlay(renderer: TerrainRender, units: Array) -> void`](DebugOverlay/functions/setup_overlay.md) — Set up overlay with renderer and the two scenario units [attacker, defender].
- [`func set_fuel_system(fs: FuelSystem) -> void`](DebugOverlay/functions/set_fuel_system.md) — Optionally bind FuelSystem explicitly if you do not use the group.
- [`func update_debug(d: Dictionary) -> void`](DebugOverlay/functions/update_debug.md)
- [`func _draw() -> void`](DebugOverlay/functions/_draw.md)
- [`func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void`](DebugOverlay/functions/_draw_unit_glyphs.md)
- [`func _icon_for_unit(su: ScenarioUnit) -> Texture2D`](DebugOverlay/functions/_icon_for_unit.md)
- [`func _draw_text_panel(d: Dictionary) -> void`](DebugOverlay/functions/_draw_text_panel.md)
- [`func _format_fuel_line(atk: ScenarioUnit, def: ScenarioUnit) -> String`](DebugOverlay/functions/_format_fuel_line.md)
- [`func _fuel_snapshot(su: ScenarioUnit) -> String`](DebugOverlay/functions/_fuel_snapshot.md) — Build "68% LOW x0.85 (-15%)" style snippets per unit.
- [`func _screen_from_m(pos_m: Vector2) -> Vector2`](DebugOverlay/functions/_screen_from_m.md)

## Public Attributes

- `TerrainRender _renderer`
- `Array[ScenarioUnit] _units`
- `Dictionary _dbg`
- `FuelSystem _fuel`

## Member Function Documentation

### setup_overlay

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void
```

Set up overlay with renderer and the two scenario units [attacker, defender].

### set_fuel_system

```gdscript
func set_fuel_system(fs: FuelSystem) -> void
```

Optionally bind FuelSystem explicitly if you do not use the group.

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

### _format_fuel_line

```gdscript
func _format_fuel_line(atk: ScenarioUnit, def: ScenarioUnit) -> String
```

### _fuel_snapshot

```gdscript
func _fuel_snapshot(su: ScenarioUnit) -> String
```

Build "68% LOW x0.85 (-15%)" style snippets per unit.

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
var _units: Array[ScenarioUnit]
```

### _dbg

```gdscript
var _dbg: Dictionary
```

### _fuel

```gdscript
var _fuel: FuelSystem
```
