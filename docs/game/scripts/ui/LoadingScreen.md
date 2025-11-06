# LoadingScreen Class Reference

*File:* `scripts/ui/LoadingScreen.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Show the loading screen with optional custom message

## Public Member Functions

- [`func _ready() -> void`](LoadingScreen/functions/_ready.md)
- [`func set_card_details() -> void`](LoadingScreen/functions/set_card_details.md) — Set scenario details in card.
- [`func hide_loading() -> void`](LoadingScreen/functions/hide_loading.md) — Hide the loading screen

## Public Attributes

- `ScenarioData _scenario` — Loading screen overlay that appears during mission initialization.
- `Label _card_title`
- `RichTextLabel _card_desc`
- `TextureRect _card_image`
- `Label _label`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### set_card_details

```gdscript
func set_card_details() -> void
```

Set scenario details in card.

### hide_loading

```gdscript
func hide_loading() -> void
```

Hide the loading screen

## Member Data Documentation

### _scenario

```gdscript
var _scenario: ScenarioData
```

Loading screen overlay that appears during mission initialization.

Displays a loading indicator and message while the simulation is in INIT state.
Automatically hides when the simulation transitions to any other state.

### _card_title

```gdscript
var _card_title: Label
```

### _card_desc

```gdscript
var _card_desc: RichTextLabel
```

### _card_image

```gdscript
var _card_image: TextureRect
```

### _label

```gdscript
var _label: Label
```
