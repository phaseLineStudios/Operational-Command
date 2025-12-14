# UnitCounter Class Reference

*File:* `scripts/sim/UnitCounter.gd`
*Class name:* `UnitCounter`
*Inherits:* `Node3D`

## Synopsis

```gdscript
class_name UnitCounter
extends Node3D
```

## Brief

Setup the counter with parameters (call before adding to scene tree)

## Public Member Functions

- [`func _ready() -> void`](UnitCounter/functions/_ready.md)
- [`func _ensure_mesh_materials(color: Color, face: Texture2D) -> void`](UnitCounter/functions/_ensure_mesh_materials.md)
- [`func _maybe_free_face_renderer() -> void`](UnitCounter/functions/_maybe_free_face_renderer.md)
- [`func _generate_face(color: Color) -> Texture2D`](UnitCounter/functions/_generate_face.md)
- [`func _counter_to_mil_affiliation(aff: CounterAffiliation) -> MilSymbol.UnitAffiliation`](UnitCounter/functions/_counter_to_mil_affiliation.md) — Convert CounterAffiliation to MilSymbol.UnitAffiliation
- [`func _mil_affiliation_to_counter(aff: MilSymbol.UnitAffiliation) -> CounterAffiliation`](UnitCounter/functions/_mil_affiliation_to_counter.md) — Convert MilSymbol.UnitAffiliation to CounterAffiliation
- [`func _get_base_color() -> Color`](UnitCounter/functions/_get_base_color.md)

## Public Attributes

- `CounterAffiliation affiliation`
- `String callsign`
- `MilSymbol.UnitType symbol_type`
- `MilSymbol.UnitSize symbol_size`
- `bool free_face_renderer_after_bake`
- `MeshInstance3D mesh`
- `SubViewport face_renderer`
- `PanelContainer face_background`
- `TextureRect face_symbol`
- `Label face_callsign`

## Public Constants

- `const _FACE_CACHE_MAX_ENTRIES: int` — Cache baked face textures to avoid repeated viewport readbacks.

## Signals

- `signal texture_ready` — Emitted when the counter texture has been generated and is ready for display

## Enumerations

- `enum CounterAffiliation`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _ensure_mesh_materials

```gdscript
func _ensure_mesh_materials(color: Color, face: Texture2D) -> void
```

### _maybe_free_face_renderer

```gdscript
func _maybe_free_face_renderer() -> void
```

### _generate_face

```gdscript
func _generate_face(color: Color) -> Texture2D
```

### _counter_to_mil_affiliation

```gdscript
func _counter_to_mil_affiliation(aff: CounterAffiliation) -> MilSymbol.UnitAffiliation
```

Convert CounterAffiliation to MilSymbol.UnitAffiliation

### _mil_affiliation_to_counter

```gdscript
func _mil_affiliation_to_counter(aff: MilSymbol.UnitAffiliation) -> CounterAffiliation
```

Convert MilSymbol.UnitAffiliation to CounterAffiliation

### _get_base_color

```gdscript
func _get_base_color() -> Color
```

## Member Data Documentation

### affiliation

```gdscript
var affiliation: CounterAffiliation
```

### callsign

```gdscript
var callsign: String
```

### symbol_type

```gdscript
var symbol_type: MilSymbol.UnitType
```

### symbol_size

```gdscript
var symbol_size: MilSymbol.UnitSize
```

### free_face_renderer_after_bake

```gdscript
var free_face_renderer_after_bake: bool
```

### mesh

```gdscript
var mesh: MeshInstance3D
```

### face_renderer

```gdscript
var face_renderer: SubViewport
```

### face_background

```gdscript
var face_background: PanelContainer
```

### face_symbol

```gdscript
var face_symbol: TextureRect
```

### face_callsign

```gdscript
var face_callsign: Label
```

## Constant Documentation

### _FACE_CACHE_MAX_ENTRIES

```gdscript
const _FACE_CACHE_MAX_ENTRIES: int
```

Cache baked face textures to avoid repeated viewport readbacks.

## Signal Documentation

### texture_ready

```gdscript
signal texture_ready
```

Emitted when the counter texture has been generated and is ready for display

## Enumeration Type Documentation

### CounterAffiliation

```gdscript
enum CounterAffiliation
```
