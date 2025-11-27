# DocumentFace Class Reference

*File:* `scripts/ui/DocumentFace.gd`
*Inherits:* `PanelContainer`

## Synopsis

```gdscript
extends PanelContainer
```

## Public Member Functions

- [`func _ready() -> void`](DocumentFace/functions/_ready.md)
- [`func update_page_indicator() -> void`](DocumentFace/functions/update_page_indicator.md) — Set the page indicator text and button visibility
- [`func _on_prev_pressed() -> void`](DocumentFace/functions/_on_prev_pressed.md) — Handle previous button click
- [`func _on_next_pressed() -> void`](DocumentFace/functions/_on_next_pressed.md) — Handle next button click
- [`func set_page(page: int) -> void`](DocumentFace/functions/set_page.md) — Set the current page
- [`func set_total_pages(count: int) -> void`](DocumentFace/functions/set_total_pages.md) — Set total pages
- [`func next_page() -> void`](DocumentFace/functions/next_page.md) — Navigate to next page
- [`func prev_page() -> void`](DocumentFace/functions/prev_page.md) — Navigate to previous page

## Public Attributes

- `RichTextLabel paper_content`
- `Label page_indicator`
- `Button prev_button`
- `Button next_button`

## Signals

- `signal page_changed(page_index: int)` — Document face with page navigation support

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### update_page_indicator

```gdscript
func update_page_indicator() -> void
```

Set the page indicator text and button visibility

### _on_prev_pressed

```gdscript
func _on_prev_pressed() -> void
```

Handle previous button click

### _on_next_pressed

```gdscript
func _on_next_pressed() -> void
```

Handle next button click

### set_page

```gdscript
func set_page(page: int) -> void
```

Set the current page

### set_total_pages

```gdscript
func set_total_pages(count: int) -> void
```

Set total pages

### next_page

```gdscript
func next_page() -> void
```

Navigate to next page

### prev_page

```gdscript
func prev_page() -> void
```

Navigate to previous page

## Member Data Documentation

### paper_content

```gdscript
var paper_content: RichTextLabel
```

### page_indicator

```gdscript
var page_indicator: Label
```

### prev_button

```gdscript
var prev_button: Button
```

### next_button

```gdscript
var next_button: Button
```

## Signal Documentation

### page_changed

```gdscript
signal page_changed(page_index: int)
```

Document face with page navigation support
