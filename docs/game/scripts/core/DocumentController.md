# DocumentController Class Reference

*File:* `scripts/core/DocumentController.gd`
*Class name:* `DocumentController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name DocumentController
extends Node
```

## Brief

Renders text content onto document clipboards in the HQ table scene.

## Detailed Description

Manages three documents:
- Intel Doc: Mission-specific intelligence items (placeholder)
- Transcript Doc: Radio communication transcript
- Briefing Doc: FRAGO SMEAC formatted mission briefing

Document face scene (contains styled RichTextLabel)

Document dimensions (fixed square viewport)

Paper texture resolution scale for anti-aliasing

Material surface index for the paper on clipboard mesh

Maximum transcript entries before pruning oldest

Refresh delay in seconds (wait for user to stop navigating)

Full document content storage

Transcript update mutex to prevent concurrent updates

Initialize the document controller with references to the clipboard nodes.
`intel` IntelDoc RigidBody3D reference
`transcript` TranscriptDoc RigidBody3D reference
`briefing` BriefingDoc RigidBody3D reference

Apply a viewport texture to a clipboard's paper material
Returns the material for future updates

Display a specific page for a document

## Public Member Functions

- [`func _setup_viewports() -> void`](DocumentController/functions/_setup_viewports.md) — Setup SubViewports for each document
- [`func _setup_refresh_timers() -> void`](DocumentController/functions/_setup_refresh_timers.md) — Setup debounce timers for texture refresh
- [`func _setup_document_input() -> void`](DocumentController/functions/_setup_document_input.md) — Setup input forwarding from 3D documents to viewports
- [`func _setup_content_labels() -> void`](DocumentController/functions/_setup_content_labels.md) — Setup document face scenes and get RichTextLabel content containers
- [`func _render_intel_doc() -> void`](DocumentController/functions/_render_intel_doc.md) — Render intel document content (placeholder)
- [`func _render_briefing_doc() -> void`](DocumentController/functions/_render_briefing_doc.md) — Render briefing document in FRAGO SMEAC format
- [`func _render_transcript_doc() -> void`](DocumentController/functions/_render_transcript_doc.md) — Render transcript document (initial render)
- [`func _update_transcript_content(follow_new_messages: bool) -> void`](DocumentController/functions/_update_transcript_content.md) — Update transcript content while preserving page position
- [`func _queue_transcript_update() -> void`](DocumentController/functions/_queue_transcript_update.md)
- [`func _do_transcript_update() -> void`](DocumentController/functions/_do_transcript_update.md)
- [`func add_transcript_entry(speaker: String, message: String) -> void`](DocumentController/functions/add_transcript_entry.md) — Add a radio transmission to the transcript
- [`func _get_mission_timestamp() -> String`](DocumentController/functions/_get_mission_timestamp.md) — Get current mission timestamp as formatted string
- [`func _apply_textures() -> void`](DocumentController/functions/_apply_textures.md) — Apply rendered textures to clipboard materials
- [`func _refresh_transcript_texture() -> void`](DocumentController/functions/_refresh_transcript_texture.md) — Refresh the transcript document texture after content updates
- [`func _refresh_texture(material: StandardMaterial3D, viewport: SubViewport) -> void`](DocumentController/functions/_refresh_texture.md) — Refresh a material's texture from viewport with mipmaps
- [`func _split_transcript_into_pages(content: RichTextLabel, full_text: String) -> Array[String]`](DocumentController/functions/_split_transcript_into_pages.md) — Split transcript into pages, keeping message blocks atomic
- [`func _split_into_pages(content: RichTextLabel, full_text: String) -> Array[String]`](DocumentController/functions/_split_into_pages.md) — Split content into pages based on what fits in the RichTextLabel
- [`func _on_intel_page_changed(page_index: int) -> void`](DocumentController/functions/_on_intel_page_changed.md) — Page change handlers - update content and debounce texture refresh
- [`func _on_transcript_page_changed(page_index: int) -> void`](DocumentController/functions/_on_transcript_page_changed.md)
- [`func _on_briefing_page_changed(page_index: int) -> void`](DocumentController/functions/_on_briefing_page_changed.md)
- [`func _do_intel_refresh() -> void`](DocumentController/functions/_do_intel_refresh.md) — Debounced refresh functions - called after timer expires
- [`func _do_transcript_refresh() -> void`](DocumentController/functions/_do_transcript_refresh.md)
- [`func _do_briefing_refresh() -> void`](DocumentController/functions/_do_briefing_refresh.md)
- [`func next_page_intel() -> void`](DocumentController/functions/next_page_intel.md) — Public API for page navigation (can be called from HQTable or input handlers)
- [`func prev_page_intel() -> void`](DocumentController/functions/prev_page_intel.md)
- [`func next_page_transcript() -> void`](DocumentController/functions/next_page_transcript.md)
- [`func prev_page_transcript() -> void`](DocumentController/functions/prev_page_transcript.md)
- [`func next_page_briefing() -> void`](DocumentController/functions/next_page_briefing.md)
- [`func prev_page_briefing() -> void`](DocumentController/functions/prev_page_briefing.md)
- [`func _get_objective_status_icon(obj_id: String) -> String`](DocumentController/functions/_get_objective_status_icon.md) — Get status icon for an objective based on MissionResolution state
- [`func _on_objective_updated(_obj_id: String, _state: int) -> void`](DocumentController/functions/_on_objective_updated.md) — Handle objective state changes and refresh briefing
- [`func _refresh_briefing_objectives() -> void`](DocumentController/functions/_refresh_briefing_objectives.md) — Refresh only the briefing objectives page

## Public Attributes

- `bool bake_viewport_mipmaps` — If true, bake a CPU ImageTexture with mipmaps from the viewport (expensive).
- `float transcript_update_delay_sec` — Delay before rebuilding transcript pages after new entries (seconds).
- `Array[AudioStream] page_change_sounds` — Sound to play when page is changed.
- `RigidBody3D intel_clipboard` — References to the clipboard RigidBody3D nodes
- `RigidBody3D transcript_clipboard`
- `RigidBody3D briefing_clipboard`
- `SubViewport _intel_viewport` — Viewports for rendering each document
- `SubViewport _transcript_viewport`
- `SubViewport _briefing_viewport`
- `Control _intel_face` — Document face instances
- `Control _transcript_face`
- `Control _briefing_face`
- `RichTextLabel _intel_content` — Content containers (RichTextLabel)
- `RichTextLabel _transcript_content`
- `RichTextLabel _briefing_content`
- `Array[String] _intel_pages` — Page tracking
- `Array[String] _transcript_pages`
- `Array[String] _briefing_pages`
- `Array[Dictionary] _transcript_entries` — Transcript storage
- `ScenarioData _scenario` — Current scenario reference
- `MissionResolution _resolution` — Mission resolution for objective tracking
- `StandardMaterial3D _intel_material` — Material references for texture updates
- `StandardMaterial3D _transcript_material`
- `StandardMaterial3D _briefing_material`
- `Timer _intel_refresh_timer` — Debounce timers for texture refresh
- `Timer _transcript_refresh_timer`
- `Timer _transcript_update_timer`
- `Timer _briefing_refresh_timer`
- `MeshInstance3D mesh_instance`
- `StandardMaterial3D material`

## Member Function Documentation

### _setup_viewports

```gdscript
func _setup_viewports() -> void
```

Setup SubViewports for each document

### _setup_refresh_timers

```gdscript
func _setup_refresh_timers() -> void
```

Setup debounce timers for texture refresh

### _setup_document_input

```gdscript
func _setup_document_input() -> void
```

Setup input forwarding from 3D documents to viewports

### _setup_content_labels

```gdscript
func _setup_content_labels() -> void
```

Setup document face scenes and get RichTextLabel content containers

### _render_intel_doc

```gdscript
func _render_intel_doc() -> void
```

Render intel document content (placeholder)

### _render_briefing_doc

```gdscript
func _render_briefing_doc() -> void
```

Render briefing document in FRAGO SMEAC format

### _render_transcript_doc

```gdscript
func _render_transcript_doc() -> void
```

Render transcript document (initial render)

### _update_transcript_content

```gdscript
func _update_transcript_content(follow_new_messages: bool) -> void
```

Update transcript content while preserving page position

### _queue_transcript_update

```gdscript
func _queue_transcript_update() -> void
```

### _do_transcript_update

```gdscript
func _do_transcript_update() -> void
```

### add_transcript_entry

```gdscript
func add_transcript_entry(speaker: String, message: String) -> void
```

Add a radio transmission to the transcript
`speaker` Who is speaking (e.g., "PLAYER", "ALPHA", "HQ")
`message` The message text

### _get_mission_timestamp

```gdscript
func _get_mission_timestamp() -> String
```

Get current mission timestamp as formatted string

### _apply_textures

```gdscript
func _apply_textures() -> void
```

Apply rendered textures to clipboard materials

### _refresh_transcript_texture

```gdscript
func _refresh_transcript_texture() -> void
```

Refresh the transcript document texture after content updates

### _refresh_texture

```gdscript
func _refresh_texture(material: StandardMaterial3D, viewport: SubViewport) -> void
```

Refresh a material's texture from viewport with mipmaps

### _split_transcript_into_pages

```gdscript
func _split_transcript_into_pages(content: RichTextLabel, full_text: String) -> Array[String]
```

Split transcript into pages, keeping message blocks atomic
Each message block (timestamp + speaker + message + blank line) stays together

### _split_into_pages

```gdscript
func _split_into_pages(content: RichTextLabel, full_text: String) -> Array[String]
```

Split content into pages based on what fits in the RichTextLabel

### _on_intel_page_changed

```gdscript
func _on_intel_page_changed(page_index: int) -> void
```

Page change handlers - update content and debounce texture refresh

### _on_transcript_page_changed

```gdscript
func _on_transcript_page_changed(page_index: int) -> void
```

### _on_briefing_page_changed

```gdscript
func _on_briefing_page_changed(page_index: int) -> void
```

### _do_intel_refresh

```gdscript
func _do_intel_refresh() -> void
```

Debounced refresh functions - called after timer expires

### _do_transcript_refresh

```gdscript
func _do_transcript_refresh() -> void
```

### _do_briefing_refresh

```gdscript
func _do_briefing_refresh() -> void
```

### next_page_intel

```gdscript
func next_page_intel() -> void
```

Public API for page navigation (can be called from HQTable or input handlers)

### prev_page_intel

```gdscript
func prev_page_intel() -> void
```

### next_page_transcript

```gdscript
func next_page_transcript() -> void
```

### prev_page_transcript

```gdscript
func prev_page_transcript() -> void
```

### next_page_briefing

```gdscript
func next_page_briefing() -> void
```

### prev_page_briefing

```gdscript
func prev_page_briefing() -> void
```

### _get_objective_status_icon

```gdscript
func _get_objective_status_icon(obj_id: String) -> String
```

Get status icon for an objective based on MissionResolution state

### _on_objective_updated

```gdscript
func _on_objective_updated(_obj_id: String, _state: int) -> void
```

Handle objective state changes and refresh briefing

### _refresh_briefing_objectives

```gdscript
func _refresh_briefing_objectives() -> void
```

Refresh only the briefing objectives page

## Member Data Documentation

### bake_viewport_mipmaps

```gdscript
var bake_viewport_mipmaps: bool
```

Decorators: `@export`

If true, bake a CPU ImageTexture with mipmaps from the viewport (expensive).

### transcript_update_delay_sec

```gdscript
var transcript_update_delay_sec: float
```

Decorators: `@export`

Delay before rebuilding transcript pages after new entries (seconds).

### page_change_sounds

```gdscript
var page_change_sounds: Array[AudioStream]
```

Decorators: `@export`

Sound to play when page is changed.

### intel_clipboard

```gdscript
var intel_clipboard: RigidBody3D
```

References to the clipboard RigidBody3D nodes

### transcript_clipboard

```gdscript
var transcript_clipboard: RigidBody3D
```

### briefing_clipboard

```gdscript
var briefing_clipboard: RigidBody3D
```

### _intel_viewport

```gdscript
var _intel_viewport: SubViewport
```

Viewports for rendering each document

### _transcript_viewport

```gdscript
var _transcript_viewport: SubViewport
```

### _briefing_viewport

```gdscript
var _briefing_viewport: SubViewport
```

### _intel_face

```gdscript
var _intel_face: Control
```

Document face instances

### _transcript_face

```gdscript
var _transcript_face: Control
```

### _briefing_face

```gdscript
var _briefing_face: Control
```

### _intel_content

```gdscript
var _intel_content: RichTextLabel
```

Content containers (RichTextLabel)

### _transcript_content

```gdscript
var _transcript_content: RichTextLabel
```

### _briefing_content

```gdscript
var _briefing_content: RichTextLabel
```

### _intel_pages

```gdscript
var _intel_pages: Array[String]
```

Page tracking

### _transcript_pages

```gdscript
var _transcript_pages: Array[String]
```

### _briefing_pages

```gdscript
var _briefing_pages: Array[String]
```

### _transcript_entries

```gdscript
var _transcript_entries: Array[Dictionary]
```

Transcript storage

### _scenario

```gdscript
var _scenario: ScenarioData
```

Current scenario reference

### _resolution

```gdscript
var _resolution: MissionResolution
```

Mission resolution for objective tracking

### _intel_material

```gdscript
var _intel_material: StandardMaterial3D
```

Material references for texture updates

### _transcript_material

```gdscript
var _transcript_material: StandardMaterial3D
```

### _briefing_material

```gdscript
var _briefing_material: StandardMaterial3D
```

### _intel_refresh_timer

```gdscript
var _intel_refresh_timer: Timer
```

Debounce timers for texture refresh

### _transcript_refresh_timer

```gdscript
var _transcript_refresh_timer: Timer
```

### _transcript_update_timer

```gdscript
var _transcript_update_timer: Timer
```

### _briefing_refresh_timer

```gdscript
var _briefing_refresh_timer: Timer
```

### mesh_instance

```gdscript
var mesh_instance: MeshInstance3D
```

### material

```gdscript
var material: StandardMaterial3D
```
