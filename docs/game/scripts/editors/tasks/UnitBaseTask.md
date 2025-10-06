# UnitBaseTask Class Reference

*File:* `scripts/editors/tasks/UnitBaseTask.gd`
*Class name:* `UnitBaseTask`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitBaseTask
extends Resource
```

## Brief

Base task definition.

## Detailed Description

A UnitTask describes a configurable behavior (e.g. Move, Defend).
Instances are placed via TaskInstance and can override properties.

Unique type id

Task Icon

Draw the task glyph

## Public Member Functions

- [`func get_configurable_props() -> Array[Dictionary]`](UnitBaseTask/functions/get_configurable_props.md) — Return list of exported properties for dynamic config UIs.
- [`func make_default_params() -> Dictionary`](UnitBaseTask/functions/make_default_params.md) — Default parameter dictionary from exported properties.

## Public Attributes

- `StringName type_id`
- `String display_name` — Display name
- `Color color` — Optional color used for overlay/links
- `Texture2D icon`
- `Texture2D itex`

## Member Function Documentation

### get_configurable_props

```gdscript
func get_configurable_props() -> Array[Dictionary]
```

Return list of exported properties for dynamic config UIs.

### make_default_params

```gdscript
func make_default_params() -> Dictionary
```

Default parameter dictionary from exported properties.

## Member Data Documentation

### type_id

```gdscript
var type_id: StringName
```

### display_name

```gdscript
var display_name: String
```

Display name

### color

```gdscript
var color: Color
```

Optional color used for overlay/links

### icon

```gdscript
var icon: Texture2D
```

### itex

```gdscript
var itex: Texture2D
```
