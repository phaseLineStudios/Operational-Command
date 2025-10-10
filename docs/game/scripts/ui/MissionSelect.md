# MissionSelect Class Reference

*File:* `scripts/ui/MissionSelect.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Mission Select controller

Shows campaign map, mission pins, and a details card.

## Detailed Description

Path to campaign select scene

Path to unit select scene

Size of each mission pin in pixels.

Show title labels next to pins.

Offset for the label relative to the pin's top-left (px).

Label background color (with alpha).

Label text color.

Label font size.

Label corner radius (px).

Extra padding inside the label panel (px).

## Public Member Functions

- [`func _ready() -> void`](MissionSelect/functions/_ready.md) — Build UI, load map, place pins, hook resizes.
- [`func _load_campaign_and_map() -> void`](MissionSelect/functions/_load_campaign_and_map.md) — Load current campaign + map.
- [`func _build_pins() -> void`](MissionSelect/functions/_build_pins.md) — Create pins and position them (normalized coords).
- [`func _make_pin(m: ScenarioData) -> BaseButton`](MissionSelect/functions/_make_pin.md) — Builds a pin control.
- [`func _apply_transparent_button_style(btn: Button) -> void`](MissionSelect/functions/_apply_transparent_button_style.md) — Remove all button styleboxes so only icon/text remains.
- [`func _attach_pin_label(pin_btn: BaseButton, title: String) -> void`](MissionSelect/functions/_attach_pin_label.md) — Create and attach a readable label to a pin button.
- [`func _refresh_pin_labels() -> void`](MissionSelect/functions/_refresh_pin_labels.md) — Refresh label visibility on all pins.
- [`func _update_pin_positions() -> void`](MissionSelect/functions/_update_pin_positions.md) — Reposition pins with letterbox awareness.
- [`func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void`](MissionSelect/functions/_on_pin_pressed.md) — Open the mission card; create/remove image node depending on presence.
- [`func _on_start_pressed() -> void`](MissionSelect/functions/_on_start_pressed.md) — Start current mission.
- [`func _on_back_pressed() -> void`](MissionSelect/functions/_on_back_pressed.md) — Return to campaign select.
- [`func _on_backdrop_gui_input(event: InputEvent) -> void`](MissionSelect/functions/_on_backdrop_gui_input.md) — Decide if an overlay click should close the card.
- [`func _point_over_any_pin(view_pt: Vector2) -> bool`](MissionSelect/functions/_point_over_any_pin.md) — True if the viewport point lies over any mission pin.
- [`func _position_card_near_pin(pin_btn: BaseButton) -> void`](MissionSelect/functions/_position_card_near_pin.md) — Place the card near a pin and keep it on-screen.
- [`func _close_card() -> void`](MissionSelect/functions/_close_card.md) — Hide card and clear selection.
- [`func _clear_children(node: Node) -> void`](MissionSelect/functions/_clear_children.md) — Remove all children from a node.

## Public Attributes

- `Texture2D pin_texture` — Optional custom pin icon; if empty, a text-dot button is used.
- `ScenarioData _selected_mission`
- `CampaignData _campaign`
- `Array[ScenarioData] _scenarios`
- `BaseButton _card_pin_button`
- `Panel _container`
- `Button _btn_back`
- `TextureRect _map_rect`
- `Control _pins_layer`
- `Panel _card`
- `Label _card_title`
- `RichTextLabel _card_desc`
- `TextureRect _card_image`
- `Label _card_diff`
- `Button _card_start`
- `Control _click_catcher`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Build UI, load map, place pins, hook resizes.

### _load_campaign_and_map

```gdscript
func _load_campaign_and_map() -> void
```

Load current campaign + map.

### _build_pins

```gdscript
func _build_pins() -> void
```

Create pins and position them (normalized coords).

### _make_pin

```gdscript
func _make_pin(m: ScenarioData) -> BaseButton
```

Builds a pin control.

### _apply_transparent_button_style

```gdscript
func _apply_transparent_button_style(btn: Button) -> void
```

Remove all button styleboxes so only icon/text remains.

### _attach_pin_label

```gdscript
func _attach_pin_label(pin_btn: BaseButton, title: String) -> void
```

Create and attach a readable label to a pin button.

### _refresh_pin_labels

```gdscript
func _refresh_pin_labels() -> void
```

Refresh label visibility on all pins.

### _update_pin_positions

```gdscript
func _update_pin_positions() -> void
```

Reposition pins with letterbox awareness.

### _on_pin_pressed

```gdscript
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void
```

Open the mission card; create/remove image node depending on presence.

### _on_start_pressed

```gdscript
func _on_start_pressed() -> void
```

Start current mission.

### _on_back_pressed

```gdscript
func _on_back_pressed() -> void
```

Return to campaign select.

### _on_backdrop_gui_input

```gdscript
func _on_backdrop_gui_input(event: InputEvent) -> void
```

Decide if an overlay click should close the card.

### _point_over_any_pin

```gdscript
func _point_over_any_pin(view_pt: Vector2) -> bool
```

True if the viewport point lies over any mission pin.

### _position_card_near_pin

```gdscript
func _position_card_near_pin(pin_btn: BaseButton) -> void
```

Place the card near a pin and keep it on-screen.

### _close_card

```gdscript
func _close_card() -> void
```

Hide card and clear selection.

### _clear_children

```gdscript
func _clear_children(node: Node) -> void
```

Remove all children from a node.

## Member Data Documentation

### pin_texture

```gdscript
var pin_texture: Texture2D
```

Decorators: `@export`

Optional custom pin icon; if empty, a text-dot button is used.

### _selected_mission

```gdscript
var _selected_mission: ScenarioData
```

### _campaign

```gdscript
var _campaign: CampaignData
```

### _scenarios

```gdscript
var _scenarios: Array[ScenarioData]
```

### _card_pin_button

```gdscript
var _card_pin_button: BaseButton
```

### _container

```gdscript
var _container: Panel
```

### _btn_back

```gdscript
var _btn_back: Button
```

### _map_rect

```gdscript
var _map_rect: TextureRect
```

### _pins_layer

```gdscript
var _pins_layer: Control
```

### _card

```gdscript
var _card: Panel
```

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

### _card_diff

```gdscript
var _card_diff: Label
```

### _card_start

```gdscript
var _card_start: Button
```

### _click_catcher

```gdscript
var _click_catcher: Control
```
