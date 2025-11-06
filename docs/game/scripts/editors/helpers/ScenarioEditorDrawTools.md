# ScenarioEditorDrawTools Class Reference

*File:* `scripts/editors/helpers/ScenarioEditorDrawTools.gd`
*Class name:* `ScenarioEditorDrawTools`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorDrawTools
extends RefCounted
```

## Brief

Helper for managing drawing tools in the Scenario Editor.

## Detailed Description

Handles freehand, stamp, and eraser tool activation, settings synchronization,
stamp pool management, and drawing ID generation.

Default settings for freehand tool

Default settings for stamp tool

## Public Member Functions

- [`func init(parent: ScenarioEditor) -> void`](ScenarioEditorDrawTools/functions/init.md) — Initialize with parent editor reference.
- [`func build_stamp_pool() -> void`](ScenarioEditorDrawTools/functions/build_stamp_pool.md) — Populate stamp list from terrain brush textures.
- [`func on_draw_click_freehand() -> void`](ScenarioEditorDrawTools/functions/on_draw_click_freehand.md) — Start freehand tool with current UI values.
- [`func on_draw_click_stamp() -> void`](ScenarioEditorDrawTools/functions/on_draw_click_stamp.md) — Start stamp tool with current UI + selected texture.
- [`func on_draw_click_eraser() -> void`](ScenarioEditorDrawTools/functions/on_draw_click_eraser.md) — Start eraser tool.
- [`func sync_freehand_opts() -> void`](ScenarioEditorDrawTools/functions/sync_freehand_opts.md) — Update active freehand tool when UI changes.
- [`func sync_stamp_opts() -> void`](ScenarioEditorDrawTools/functions/sync_stamp_opts.md) — Update active stamp tool when UI changes.
- [`func on_stamp_selected(idx: int) -> void`](ScenarioEditorDrawTools/functions/on_stamp_selected.md) — Handle stamp selection change.
- [`func on_stamp_load_clicked() -> void`](ScenarioEditorDrawTools/functions/on_stamp_load_clicked.md) — Load a texture from disk into pool.
- [`func next_drawing_id(kind: String) -> String`](ScenarioEditorDrawTools/functions/next_drawing_id.md) — Generate unique drawing id.

## Public Attributes

- `ScenarioEditor editor` — Reference to parent ScenarioEditor
- `Array[Texture2D] draw_textures` — Cached drawing textures loaded from stamp pool
- `Array[String] draw_tex_paths` — Paths to cached drawing textures

## Member Function Documentation

### init

```gdscript
func init(parent: ScenarioEditor) -> void
```

Initialize with parent editor reference.
`parent` Parent ScenarioEditor instance.

### build_stamp_pool

```gdscript
func build_stamp_pool() -> void
```

Populate stamp list from terrain brush textures.

### on_draw_click_freehand

```gdscript
func on_draw_click_freehand() -> void
```

Start freehand tool with current UI values.

### on_draw_click_stamp

```gdscript
func on_draw_click_stamp() -> void
```

Start stamp tool with current UI + selected texture.

### on_draw_click_eraser

```gdscript
func on_draw_click_eraser() -> void
```

Start eraser tool.

### sync_freehand_opts

```gdscript
func sync_freehand_opts() -> void
```

Update active freehand tool when UI changes.

### sync_stamp_opts

```gdscript
func sync_stamp_opts() -> void
```

Update active stamp tool when UI changes.

### on_stamp_selected

```gdscript
func on_stamp_selected(idx: int) -> void
```

Handle stamp selection change.
`idx` Item index.

### on_stamp_load_clicked

```gdscript
func on_stamp_load_clicked() -> void
```

Load a texture from disk into pool.

### next_drawing_id

```gdscript
func next_drawing_id(kind: String) -> String
```

Generate unique drawing id.
`kind` "stroke" | "stamp".
[return] Unique drawing ID string.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Reference to parent ScenarioEditor

### draw_textures

```gdscript
var draw_textures: Array[Texture2D]
```

Cached drawing textures loaded from stamp pool

### draw_tex_paths

```gdscript
var draw_tex_paths: Array[String]
```

Paths to cached drawing textures
