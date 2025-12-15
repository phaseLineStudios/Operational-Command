# ScenarioEditorMenus Class Reference

*File:* `scripts/editors/helpers/ScenarioEditorMenus.gd`
*Class name:* `ScenarioEditorMenus`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorMenus
extends RefCounted
```

## Brief

Helper for managing menus and dialogs in the Scenario Editor.

## Detailed Description

Handles menu button actions (File, Attributes) and opening configuration dialogs
for slots, units, tasks, triggers, and custom commands.

Path to return to main menu scene

## Public Member Functions

- [`func init(parent: ScenarioEditor) -> void`](ScenarioEditorMenus/functions/init.md) — Initialize with parent editor reference.
- [`func on_filemenu_pressed(id: int) -> void`](ScenarioEditorMenus/functions/on_filemenu_pressed.md) — Handle File menu actions (New/Open/Save/Save As/Back).
- [`func on_attributemenu_pressed(id: int) -> void`](ScenarioEditorMenus/functions/on_attributemenu_pressed.md) — Handle Attributes menu actions (Edit Scenario/Briefing/Weather).
- [`func open_slot_config(index: int) -> void`](ScenarioEditorMenus/functions/open_slot_config.md) — Open slot configuration dialog for a slot index.
- [`func open_unit_config(index: int) -> void`](ScenarioEditorMenus/functions/open_unit_config.md) — Open unit configuration dialog for a unit index.
- [`func open_task_config(task_index: int) -> void`](ScenarioEditorMenus/functions/open_task_config.md) — Open task configuration dialog for a task index.
- [`func open_trigger_config(index: int) -> void`](ScenarioEditorMenus/functions/open_trigger_config.md) — Open trigger configuration dialog for a trigger index.
- [`func open_command_config(index: int) -> void`](ScenarioEditorMenus/functions/open_command_config.md) — Open custom command configuration dialog for a command index.
- [`func _on_quit_requested() -> void`](ScenarioEditorMenus/functions/_on_quit_requested.md) — Handle quit request with unsaved changes confirmation

## Public Attributes

- `ScenarioEditor editor` — Reference to parent ScenarioEditor

## Member Function Documentation

### init

```gdscript
func init(parent: ScenarioEditor) -> void
```

Initialize with parent editor reference.
`parent` Parent ScenarioEditor instance.

### on_filemenu_pressed

```gdscript
func on_filemenu_pressed(id: int) -> void
```

Handle File menu actions (New/Open/Save/Save As/Back).
`id` Menu item ID.

### on_attributemenu_pressed

```gdscript
func on_attributemenu_pressed(id: int) -> void
```

Handle Attributes menu actions (Edit Scenario/Briefing/Weather).
`id` Menu item ID.

### open_slot_config

```gdscript
func open_slot_config(index: int) -> void
```

Open slot configuration dialog for a slot index.
`index` Slot index.

### open_unit_config

```gdscript
func open_unit_config(index: int) -> void
```

Open unit configuration dialog for a unit index.
`index` Unit index.

### open_task_config

```gdscript
func open_task_config(task_index: int) -> void
```

Open task configuration dialog for a task index.
`task_index` Task index.

### open_trigger_config

```gdscript
func open_trigger_config(index: int) -> void
```

Open trigger configuration dialog for a trigger index.
`index` Trigger index.

### open_command_config

```gdscript
func open_command_config(index: int) -> void
```

Open custom command configuration dialog for a command index.
`index` Custom command index.

### _on_quit_requested

```gdscript
func _on_quit_requested() -> void
```

Handle quit request with unsaved changes confirmation

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Reference to parent ScenarioEditor
