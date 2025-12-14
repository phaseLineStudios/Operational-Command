# OCMenuItemList Class Reference

*File:* `scripts/ui/controls/OcMenuItemList.gd`
*Class name:* `OCMenuItemList`
*Inherits:* `ItemList`

## Synopsis

```gdscript
class_name OCMenuItemList
extends ItemList
```

## Public Member Functions

- [`func _ready() -> void`](OCMenuItemList/functions/_ready.md)
- [`func _gui_input(event: InputEvent) -> void`](OCMenuItemList/functions/_gui_input.md)
- [`func _handle_hover(mouse_pos: Vector2) -> void`](OCMenuItemList/functions/_handle_hover.md)
- [`func _on_mouse_exited() -> void`](OCMenuItemList/functions/_on_mouse_exited.md)
- [`func _on_item_clicked(_idx: int, _pos: Vector2, mouse_button_index: int) -> void`](OCMenuItemList/functions/_on_item_clicked.md)
- [`func _play_hover(item_index: int) -> void`](OCMenuItemList/functions/_play_hover.md)
- [`func _play_click(item_index: int) -> void`](OCMenuItemList/functions/_play_click.md)

## Public Attributes

- `Array[AudioStream] hover_sounds`
- `Array[AudioStream] hover_disabled_sounds`
- `Array[AudioStream] click_sounds`
- `Array[AudioStream] click_disabled_sounds`
- `int _last_hovered_item`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _gui_input

```gdscript
func _gui_input(event: InputEvent) -> void
```

### _handle_hover

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void
```

### _on_mouse_exited

```gdscript
func _on_mouse_exited() -> void
```

### _on_item_clicked

```gdscript
func _on_item_clicked(_idx: int, _pos: Vector2, mouse_button_index: int) -> void
```

### _play_hover

```gdscript
func _play_hover(item_index: int) -> void
```

### _play_click

```gdscript
func _play_click(item_index: int) -> void
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

### _last_hovered_item

```gdscript
var _last_hovered_item: int
```
