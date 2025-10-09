# SpeechWordlistUpdater Class Reference

*File:* `scripts/radio/WordListUpdater.gd`
*Class name:* `SpeechWordlistUpdater`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name SpeechWordlistUpdater
extends Node
```

## Brief

Updates the speech recognizer's grammar per mission.

## Detailed Description

Builds a mission-scoped Vosk word list from unit callsigns and
TerrainData labels, then pushes it to the recognizer.
On mission start (RUN/RUNNING), it refreshes the list automatically.

Simulation world that emits the mission state changes used to trigger refresh.

Terrain renderer providing access to `member TerrainRender.data.labels`.

Vosk recognizer instance exposing `set_wordlist(String)`.

## Public Member Functions

- [`func _ready() -> void`](SpeechWordlistUpdater/functions/_ready.md) — Connects mission state change and performs an initial refresh.
- [`func bind_recognizer(r: Vosk) -> void`](SpeechWordlistUpdater/functions/bind_recognizer.md) — Bind or replace the active recognizer.
- [`func _on_state_changed(_prev, next) -> void`](SpeechWordlistUpdater/functions/_on_state_changed.md) — Handles mission state transitions.
- [`func _refresh_wordlist() -> void`](SpeechWordlistUpdater/functions/_refresh_wordlist.md) — Rebuilds the word list from mission callsigns and map labels,
serializes it to JSON, and applies it to the recognizer.
- [`func _collect_mission_callsigns() -> Array[String]`](SpeechWordlistUpdater/functions/_collect_mission_callsigns.md) — Collects callsigns from both scenario units and playable units.
- [`func _collect_terrain_labels() -> Array[String]`](SpeechWordlistUpdater/functions/_collect_terrain_labels.md) — Extracts map label texts from `member TerrainRender.data.labels`.
- [`func _dedup_preserve(arr: Array[String]) -> Array[String]`](SpeechWordlistUpdater/functions/_dedup_preserve.md) — De-duplicates an array while preserving order.

## Public Attributes

- `SimWorld sim`
- `TerrainRender terrain_renderer`
- `Vosk recognizer`

## Signals

- `signal wordlist_updated(count: int)` — Emitted after the recognizer's word list is updated.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Connects mission state change and performs an initial refresh.

### bind_recognizer

```gdscript
func bind_recognizer(r: Vosk) -> void
```

Bind or replace the active recognizer.
Use when the recognizer is created after this node is ready.
[param r] Recognizer instance exposing `set_wordlist(String)`.

### _on_state_changed

```gdscript
func _on_state_changed(_prev, next) -> void
```

Handles mission state transitions.
Refreshes the word list when the new state string contains "RUN".
[param _prev] Previous state (unused).
[param next] New state token or enum string.

### _refresh_wordlist

```gdscript
func _refresh_wordlist() -> void
```

Rebuilds the word list from mission callsigns and map labels,
serializes it to JSON, and applies it to the recognizer.

### _collect_mission_callsigns

```gdscript
func _collect_mission_callsigns() -> Array[String]
```

Collects callsigns from both scenario units and playable units.
Returns a lowercase, de-duplicated list.
[return] Array[String] of callsigns.

### _collect_terrain_labels

```gdscript
func _collect_terrain_labels() -> Array[String]
```

Extracts map label texts from `member TerrainRender.data.labels`.
Returns a de-duplicated list (original casing).
[return] Array[String] of label texts.

### _dedup_preserve

```gdscript
func _dedup_preserve(arr: Array[String]) -> Array[String]
```

De-duplicates an array while preserving order.
[param arr] Input list.
[return] New list with unique items, first occurrence kept.

## Member Data Documentation

### sim

```gdscript
var sim: SimWorld
```

### terrain_renderer

```gdscript
var terrain_renderer: TerrainRender
```

### recognizer

```gdscript
var recognizer: Vosk
```

## Signal Documentation

### wordlist_updated

```gdscript
signal wordlist_updated(count: int)
```

Emitted after the recognizer's word list is updated.
[param count] Number of entries in the applied word list.
