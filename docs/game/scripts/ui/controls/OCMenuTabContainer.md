# OCMenuTabContainer Class Reference

*File:* `scripts/ui/controls/OcMenuTabContainer.gd`
*Class name:* `OCMenuTabContainer`
*Inherits:* `TabContainer`

## Synopsis

```gdscript
class_name OCMenuTabContainer
extends TabContainer
```

## Public Member Functions

- [`func _ready() -> void`](OCMenuTabContainer/functions/_ready.md)
- [`func _on_tab_bar_input(event: InputEvent) -> void`](OCMenuTabContainer/functions/_on_tab_bar_input.md)
- [`func _handle_hover(mouse_pos: Vector2) -> void`](OCMenuTabContainer/functions/_handle_hover.md)
- [`func _on_tab_bar_mouse_exited() -> void`](OCMenuTabContainer/functions/_on_tab_bar_mouse_exited.md)
- [`func _on_tab_changed(tab_index: int) -> void`](OCMenuTabContainer/functions/_on_tab_changed.md)
- [`func _play_hover(tab_index: int) -> void`](OCMenuTabContainer/functions/_play_hover.md)
- [`func _play_click(tab_index: int) -> void`](OCMenuTabContainer/functions/_play_click.md)

## Public Attributes

- `Array[AudioStream] hover_sounds`
- `Array[AudioStream] hover_disabled_sounds`
- `Array[AudioStream] click_sounds`
- `Array[AudioStream] click_disabled_sounds`
- `int _last_hovered_tab`
- `TabBar _tab_bar`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _on_tab_bar_input

```gdscript
func _on_tab_bar_input(event: InputEvent) -> void
```

### _handle_hover

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void
```

### _on_tab_bar_mouse_exited

```gdscript
func _on_tab_bar_mouse_exited() -> void
```

### _on_tab_changed

```gdscript
func _on_tab_changed(tab_index: int) -> void
```

### _play_hover

```gdscript
func _play_hover(tab_index: int) -> void
```

### _play_click

```gdscript
func _play_click(tab_index: int) -> void
```

## Member Data Documentation

### hover_sounds

```gdscript
var hover_sounds: Array[AudioStream]
```

### hover_disabled_sounds

```gdscript
var hover_disabled_sounds: Array[AudioStream]
```

### click_sounds

```gdscript
var click_sounds: Array[AudioStream]
```

### click_disabled_sounds

```gdscript
var click_disabled_sounds: Array[AudioStream]
```

### _last_hovered_tab

```gdscript
var _last_hovered_tab: int
```

### _tab_bar

```gdscript
var _tab_bar: TabBar
```
