# SubtitleTrack Class Reference

*File:* `scripts/data/SubtitleTrack.gd`
*Class name:* `SubtitleTrack`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name SubtitleTrack
extends Resource
```

## Brief

Reusable subtitle track resource for video or audio playback.

## Detailed Description

Contains an array of subtitle entries with timing and text.

## Public Member Functions

- [`func add_subtitle(start: float, end: float, text: String) -> void`](SubtitleTrack/functions/add_subtitle.md) — Add a subtitle entry
- [`func get_subtitle_at_time(time: float) -> String`](SubtitleTrack/functions/get_subtitle_at_time.md) — Get subtitle at specific time position
- [`func get_all_subtitles() -> Array[Subtitle]`](SubtitleTrack/functions/get_all_subtitles.md) — Get all subtitles as Subtitle objects
- [`func serialize() -> Dictionary`](SubtitleTrack/functions/serialize.md) — Serialize subtitle track to dictionary (for JSON export)
- [`func deserialize(data: Dictionary) -> void`](SubtitleTrack/functions/deserialize.md) — Deserialize subtitle track from dictionary (for JSON import)

## Public Attributes

- `Array[Subtitle] subtitles` — Array of subtitle entries

## Member Function Documentation

### add_subtitle

```gdscript
func add_subtitle(start: float, end: float, text: String) -> void
```

Add a subtitle entry

### get_subtitle_at_time

```gdscript
func get_subtitle_at_time(time: float) -> String
```

Get subtitle at specific time position

### get_all_subtitles

```gdscript
func get_all_subtitles() -> Array[Subtitle]
```

Get all subtitles as Subtitle objects

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize subtitle track to dictionary (for JSON export)

### deserialize

```gdscript
func deserialize(data: Dictionary) -> void
```

Deserialize subtitle track from dictionary (for JSON import)

## Member Data Documentation

### subtitles

```gdscript
var subtitles: Array[Subtitle]
```

Decorators: `@export`

Array of subtitle entries
