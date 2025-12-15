# Briefing Class Reference

*File:* `scripts/ui/Briefing.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Briefing controller

Shows a whiteboard with pinned docs/photos; click to open a zoomable viewer.

## Detailed Description

Default thumb size.

## Public Member Functions

- [`func _ready() -> void`](Briefing/functions/_ready.md) — Init: load data, build board, wire UI.
- [`func _load_brief() -> void`](Briefing/functions/_load_brief.md) — Load the new-structure brief (your schema).
- [`func _build_board() -> void`](Briefing/functions/_build_board.md) — Put the whiteboard background.
- [`func _on_back_pressed() -> void`](Briefing/functions/_on_back_pressed.md) — Handle back button press

## Public Attributes

- `Texture2D default_whiteboard` — Whiteboard Texture
- `BriefData _brief`
- `Array _items`
- `Button _btn_back`
- `Button _btn_next`
- `Label _title`
- `TextureRect _whiteboard`

## Public Constants

- `const SCENE_MISSION_SELECT`
- `const SCENE_UNIT_SELECT`

## Enumerations

- `enum ItemType` — Types of briefing items.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Init: load data, build board, wire UI.

### _load_brief

```gdscript
func _load_brief() -> void
```

Load the new-structure brief (your schema).

### _build_board

```gdscript
func _build_board() -> void
```

Put the whiteboard background.

### _on_back_pressed

```gdscript
func _on_back_pressed() -> void
```

Handle back button press

## Member Data Documentation

### default_whiteboard

```gdscript
var default_whiteboard: Texture2D
```

Decorators: `@export`

Whiteboard Texture

### _brief

```gdscript
var _brief: BriefData
```

### _items

```gdscript
var _items: Array
```

### _btn_back

```gdscript
var _btn_back: Button
```

### _btn_next

```gdscript
var _btn_next: Button
```

### _title

```gdscript
var _title: Label
```

### _whiteboard

```gdscript
var _whiteboard: TextureRect
```

## Constant Documentation

### SCENE_MISSION_SELECT

```gdscript
const SCENE_MISSION_SELECT
```

### SCENE_UNIT_SELECT

```gdscript
const SCENE_UNIT_SELECT
```

## Enumeration Type Documentation

### ItemType

```gdscript
enum ItemType
```

Types of briefing items.
