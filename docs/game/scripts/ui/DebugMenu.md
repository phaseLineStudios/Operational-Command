# DebugMenu Class Reference

*File:* `scripts/ui/DebugMenu.gd`
*Class name:* `DebugMenu`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name DebugMenu
extends Window
```

## Public Member Functions

- [`func _ready()`](DebugMenu/functions/_ready.md)
- [`func _set_metrics_visibility(visibility: int)`](DebugMenu/functions/_set_metrics_visibility.md) — Set visibility for metrics display
- [`func _on_load_pressed() -> void`](DebugMenu/functions/_on_load_pressed.md) — Load scene
- [`func _populate_scene_list() -> void`](DebugMenu/functions/_populate_scene_list.md) — populate optionbutton with scenes
- [`func _collect_scenes(root: String) -> Array`](DebugMenu/functions/_collect_scenes.md) — Collect all scenes
- [`func _recursive_collect_scenes(path: String, out: Array) -> void`](DebugMenu/functions/_recursive_collect_scenes.md) — recursivly collect all scenes in project
- [`func _pretty_scene_name(p: String) -> String`](DebugMenu/functions/_pretty_scene_name.md) — Prettify scene name
- [`func _log_msg(msg: String, lvl: LogService.LogLevel) -> void`](DebugMenu/functions/_log_msg.md) — Capture and store log message
- [`func _refresh_log()`](DebugMenu/functions/_refresh_log.md) — refresh log display
- [`func _clear_log()`](DebugMenu/functions/_clear_log.md)
- [`func _process(_dt: float) -> void`](DebugMenu/functions/_process.md)
- [`func _close()`](DebugMenu/functions/_close.md)

## Public Attributes

- `Array _log_lines`
- `DebugMetricsDisplay metrics_display`
- `OptionButton metrics_visibility`
- `OptionButton scene_loader_scene`
- `Button scene_loader_button`
- `RichTextLabel event_log_content`
- `Button event_log_clear`
- `Button event_log_filter_log`
- `Button event_log_filter_info`
- `Button event_log_filter_warning`
- `Button event_log_filter_error`
- `Button event_log_filter_trace`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _set_metrics_visibility

```gdscript
func _set_metrics_visibility(visibility: int)
```

Set visibility for metrics display

### _on_load_pressed

```gdscript
func _on_load_pressed() -> void
```

Load scene

### _populate_scene_list

```gdscript
func _populate_scene_list() -> void
```

populate optionbutton with scenes

### _collect_scenes

```gdscript
func _collect_scenes(root: String) -> Array
```

Collect all scenes

### _recursive_collect_scenes

```gdscript
func _recursive_collect_scenes(path: String, out: Array) -> void
```

recursivly collect all scenes in project

### _pretty_scene_name

```gdscript
func _pretty_scene_name(p: String) -> String
```

Prettify scene name

### _log_msg

```gdscript
func _log_msg(msg: String, lvl: LogService.LogLevel) -> void
```

Capture and store log message

### _refresh_log

```gdscript
func _refresh_log()
```

refresh log display

### _clear_log

```gdscript
func _clear_log()
```

### _process

```gdscript
func _process(_dt: float) -> void
```

### _close

```gdscript
func _close()
```

## Member Data Documentation

### _log_lines

```gdscript
var _log_lines: Array
```

### metrics_display

```gdscript
var metrics_display: DebugMetricsDisplay
```

### metrics_visibility

```gdscript
var metrics_visibility: OptionButton
```

### scene_loader_scene

```gdscript
var scene_loader_scene: OptionButton
```

### scene_loader_button

```gdscript
var scene_loader_button: Button
```

### event_log_content

```gdscript
var event_log_content: RichTextLabel
```

### event_log_clear

```gdscript
var event_log_clear: Button
```

### event_log_filter_log

```gdscript
var event_log_filter_log: Button
```

### event_log_filter_info

```gdscript
var event_log_filter_info: Button
```

### event_log_filter_warning

```gdscript
var event_log_filter_warning: Button
```

### event_log_filter_error

```gdscript
var event_log_filter_error: Button
```

### event_log_filter_trace

```gdscript
var event_log_filter_trace: Button
```
