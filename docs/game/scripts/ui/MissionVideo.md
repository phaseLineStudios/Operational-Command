# MissionVideo Class Reference

*File:* `scripts/ui/MissionVideo.gd`
*Class name:* `MissionVideo`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name MissionVideo
extends Control
```

## Brief

Path to unit select scene

## Detailed Description

Duration to hold space to skip (seconds)

Duration of mouse inactivity before hiding UI (seconds)

## Public Member Functions

- [`func _ready() -> void`](MissionVideo/functions/_ready.md)
- [`func _process(delta: float) -> void`](MissionVideo/functions/_process.md)
- [`func _handle_space_hold(delta: float) -> void`](MissionVideo/functions/_handle_space_hold.md)
- [`func _handle_mouse_hide(delta: float) -> void`](MissionVideo/functions/_handle_mouse_hide.md)
- [`func _show_ui() -> void`](MissionVideo/functions/_show_ui.md)
- [`func _hide_ui() -> void`](MissionVideo/functions/_hide_ui.md)
- [`func _on_skip_pressed() -> void`](MissionVideo/functions/_on_skip_pressed.md)
- [`func _load_subtitles() -> void`](MissionVideo/functions/_load_subtitles.md)
- [`func _update_subtitles() -> void`](MissionVideo/functions/_update_subtitles.md)

## Public Attributes

- `SubtitleTrack _subtitle_track`
- `VideoStreamPlayer player`
- `Label subtitles_lbl`
- `ProgressBar hold_progress`
- `Label hold_label`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(delta: float) -> void
```

### _handle_space_hold

```gdscript
func _handle_space_hold(delta: float) -> void
```

### _handle_mouse_hide

```gdscript
func _handle_mouse_hide(delta: float) -> void
```

### _show_ui

```gdscript
func _show_ui() -> void
```

### _hide_ui

```gdscript
func _hide_ui() -> void
```

### _on_skip_pressed

```gdscript
func _on_skip_pressed() -> void
```

### _load_subtitles

```gdscript
func _load_subtitles() -> void
```

### _update_subtitles

```gdscript
func _update_subtitles() -> void
```

## Member Data Documentation

### _subtitle_track

```gdscript
var _subtitle_track: SubtitleTrack
```

### player

```gdscript
var player: VideoStreamPlayer
```

### subtitles_lbl

```gdscript
var subtitles_lbl: Label
```

### hold_progress

```gdscript
var hold_progress: ProgressBar
```

### hold_label

```gdscript
var hold_label: Label
```
