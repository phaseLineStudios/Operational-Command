# ScenarioEditorDeletionOps Class Reference

*File:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd`
*Class name:* `ScenarioEditorDeletionOps`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorDeletionOps
extends RefCounted
```

## Brief

Helper for managing deletion operations in the Scenario Editor.

## Detailed Description

Handles deletion of units, slots, tasks, triggers, and custom commands,
including reference reindexing, chain link repairs, and history integration.

## Public Member Functions

- [`func init(parent: ScenarioEditor) -> void`](ScenarioEditorDeletionOps/functions/init.md) — Initialize with parent editor reference.
- [`func delete_pick(pick: Dictionary) -> void`](ScenarioEditorDeletionOps/functions/delete_pick.md) — Route deletion to the correct entity handler.
- [`func delete_unit(unit_index: int) -> void`](ScenarioEditorDeletionOps/functions/delete_unit.md) — Delete a unit and all its tasks; reindex references; push history.
- [`func delete_slot(slot_index: int) -> void`](ScenarioEditorDeletionOps/functions/delete_slot.md) — Delete a slot; push history and refresh.
- [`func delete_task(task_index: int) -> void`](ScenarioEditorDeletionOps/functions/delete_task.md) — Delete a task; repair chain links and reindex; push history.
- [`func delete_trigger(trigger_index: int) -> void`](ScenarioEditorDeletionOps/functions/delete_trigger.md) — Delete a trigger; push history and refresh.
- [`func delete_command(command_index: int) -> void`](ScenarioEditorDeletionOps/functions/delete_command.md) — Delete a custom command; push history and refresh.
- [`func _snapshot_arrays() -> Dictionary`](ScenarioEditorDeletionOps/functions/_snapshot_arrays.md) — Deep-copy key arrays for history operations.

## Public Attributes

- `ScenarioEditor editor` — Reference to parent ScenarioEditor

## Member Function Documentation

### init

```gdscript
func init(parent: ScenarioEditor) -> void
```

Initialize with parent editor reference.
`parent` Parent ScenarioEditor instance.

### delete_pick

```gdscript
func delete_pick(pick: Dictionary) -> void
```

Route deletion to the correct entity handler.
`pick` Selection dictionary with "type" and "index".

### delete_unit

```gdscript
func delete_unit(unit_index: int) -> void
```

Delete a unit and all its tasks; reindex references; push history.
`unit_index` Index of unit to delete.

### delete_slot

```gdscript
func delete_slot(slot_index: int) -> void
```

Delete a slot; push history and refresh.
`slot_index` Index of slot to delete.

### delete_task

```gdscript
func delete_task(task_index: int) -> void
```

Delete a task; repair chain links and reindex; push history.
`task_index` Index of task to delete.

### delete_trigger

```gdscript
func delete_trigger(trigger_index: int) -> void
```

Delete a trigger; push history and refresh.
`trigger_index` Index of trigger to delete.

### delete_command

```gdscript
func delete_command(command_index: int) -> void
```

Delete a custom command; push history and refresh.
`command_index` Index of custom command to delete.

### _snapshot_arrays

```gdscript
func _snapshot_arrays() -> Dictionary
```

Deep-copy key arrays for history operations.
[return] Dictionary with deep copies of units, unit_slots, tasks, and triggers arrays.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Reference to parent ScenarioEditor
