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

Show title tooltip for pins.

## Public Member Functions

- [`func _ready() -> void`](MissionSelect/functions/_ready.md) — Build UI, load map, place pins, hook resizes.
- [`func _load_campaign_and_map() -> void`](MissionSelect/functions/_load_campaign_and_map.md) — Load current campaign + map.
- [`func _build_pins() -> void`](MissionSelect/functions/_build_pins.md) — Create pins and position them (normalized coords).
- [`func _make_pin(m: ScenarioData) -> BaseButton`](MissionSelect/functions/_make_pin.md) — Builds a pin control.
- [`func _apply_transparent_button_style(btn: Button) -> void`](MissionSelect/functions/_apply_transparent_button_style.md) — Remove all button styleboxes so only icon/text remains.
- [`func _update_pin_positions() -> void`](MissionSelect/functions/_update_pin_positions.md) — Reposition pins with letterbox awareness.
- [`func _update_pin_highlight() -> void`](MissionSelect/functions/_update_pin_highlight.md) — Highlight latest unlocked mission pin and fade previous ones.
- [`func _on_pin_mouse_entered(pin: Control) -> void`](MissionSelect/functions/_on_pin_mouse_entered.md) — Temporarily restore full alpha while hovering a pin.
- [`func _on_pin_mouse_exited(pin: Control) -> void`](MissionSelect/functions/_on_pin_mouse_exited.md) — Restore highlight alpha when mouse leaves.
- [`func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void`](MissionSelect/functions/_on_pin_pressed.md) — Open the mission card; create/remove image node depending on presence.
- [`func _on_start_pressed() -> void`](MissionSelect/functions/_on_start_pressed.md) — Start current mission.
- [`func _on_back_pressed() -> void`](MissionSelect/functions/_on_back_pressed.md) — Return to campaign select.
- [`func _on_backdrop_gui_input(event: InputEvent) -> void`](MissionSelect/functions/_on_backdrop_gui_input.md) — Decide if an overlay click should close the card.
- [`func _point_over_any_pin(view_pt: Vector2) -> bool`](MissionSelect/functions/_point_over_any_pin.md) — True if the viewport point lies over any mission pin.
- [`func _close_card() -> void`](MissionSelect/functions/_close_card.md) — Hide card and clear selection.
- [`func _update_mission_locked_states() -> void`](MissionSelect/functions/_update_mission_locked_states.md) — Update which missions are locked based on campaign progression.
- [`func is_mission_available(mission: ScenarioData) -> bool`](MissionSelect/functions/is_mission_available.md) — Check if a mission is available to play.
- [`func _on_pins_layer_draw() -> void`](MissionSelect/functions/_on_pins_layer_draw.md) — Draw mission path between pins in campaign order.
- [`func _clear_children(node: Node) -> void`](MissionSelect/functions/_clear_children.md) — Remove all children from a node.

## Public Attributes

- `Texture2D pin_texture` — Optional custom pin icon; if empty, a text-dot button is used.
- `Array[AudioStream] pin_hover_sounds` — Sound to play when hovering over a pin
- `Array[AudioStream] pin_click_sounds` — Sound to play when clicking a pin
- `ScenarioData _selected_mission`
- `CampaignData _campaign`
- `Array[ScenarioData] _scenarios`
- `BaseButton _card_pin_button`
- `Dictionary _mission_locked`
- `Dictionary _pin_centers_by_id`
- `OCMenuContainer _container`
- `OCMenuButton _btn_back`
- `TextureRect _map_rect`
- `Control _pins_layer`
- `OCMenuContainer _card`
- `Label _card_title`
- `RichTextLabel _card_desc`
- `TextureRect _card_image`
- `Label _card_diff`
- `OCMenuButton _card_start`
- `OCMenuButton _card_close`
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

### _update_pin_positions

```gdscript
func _update_pin_positions() -> void
```

Reposition pins with letterbox awareness.

### _update_pin_highlight

```gdscript
func _update_pin_highlight() -> void
```

Highlight latest unlocked mission pin and fade previous ones.

### _on_pin_mouse_entered

```gdscript
func _on_pin_mouse_entered(pin: Control) -> void
```

Temporarily restore full alpha while hovering a pin.

### _on_pin_mouse_exited

```gdscript
func _on_pin_mouse_exited(pin: Control) -> void
```

Restore highlight alpha when mouse leaves.

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

### _close_card

```gdscript
func _close_card() -> void
```

Hide card and clear selection.

### _update_mission_locked_states

```gdscript
func _update_mission_locked_states() -> void
```

Update which missions are locked based on campaign progression.
First mission is always unlocked; subsequent missions require previous mission completion.

### is_mission_available

```gdscript
func is_mission_available(mission: ScenarioData) -> bool
```

Check if a mission is available to play.

### _on_pins_layer_draw

```gdscript
func _on_pins_layer_draw() -> void
```

Draw mission path between pins in campaign order.

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

### pin_hover_sounds

```gdscript
var pin_hover_sounds: Array[AudioStream]
```

Decorators: `@export`

Sound to play when hovering over a pin

### pin_click_sounds

```gdscript
var pin_click_sounds: Array[AudioStream]
```

Decorators: `@export`

Sound to play when clicking a pin

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

### _mission_locked

```gdscript
var _mission_locked: Dictionary
```

### _pin_centers_by_id

```gdscript
var _pin_centers_by_id: Dictionary
```

### _container

```gdscript
var _container: OCMenuContainer
```

### _btn_back

```gdscript
var _btn_back: OCMenuButton
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
var _card: OCMenuContainer
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
var _card_start: OCMenuButton
```

### _card_close

```gdscript
var _card_close: OCMenuButton
```

### _click_catcher

```gdscript
var _click_catcher: Control
```
