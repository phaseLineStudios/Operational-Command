# ScenarioUnitsCatalog Class Reference

*File:* `scripts/editors/services/ScenarioUnitsCatalog.gd`
*Class name:* `ScenarioUnitsCatalog`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioUnitsCatalog
extends RefCounted
```

## Public Member Functions

- [`func setup(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/setup.md)
- [`func _build_categories(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_build_categories.md)
- [`func _set_faction(ctx: ScenarioEditorContext, aff) -> void`](ScenarioUnitsCatalog/functions/_set_faction.md)
- [`func _setup_tree(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_setup_tree.md)
- [`func _on_tree_item(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_on_tree_item.md)
- [`func _refresh(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_refresh.md)
- [`func _setup_unit_create(ctx: ScenarioEditorContext)`](ScenarioUnitsCatalog/functions/_setup_unit_create.md)
- [`func _on_create_pressed(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_on_create_pressed.md)
- [`func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void`](ScenarioUnitsCatalog/functions/_on_unit_saved.md)
- [`func _on_dialog_closed(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_on_dialog_closed.md) — Called when dialog is closed without saving
- [`func _get_selected_unit(ctx: ScenarioEditorContext) -> UnitData`](ScenarioUnitsCatalog/functions/_get_selected_unit.md) — Get the UnitData from the current selection.
- [`func _used_unit_ids(ctx: ScenarioEditorContext) -> Dictionary`](ScenarioUnitsCatalog/functions/_used_unit_ids.md)
- [`func _update_button_text(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_update_button_text.md) — Update the create/edit button text based on current selection
- [`func _deselect_unit(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_deselect_unit.md) — Deselect the currently selected unit in the tree
- [`func _cancel_active_tool(ctx: ScenarioEditorContext) -> void`](ScenarioUnitsCatalog/functions/_cancel_active_tool.md) — Cancel the active tool if one is running

## Public Attributes

- `Array[UnitData] all_units`
- `Array[UnitCategoryData] unit_categories`
- `UnitCategoryData selected_category`

## Member Function Documentation

### setup

```gdscript
func setup(ctx: ScenarioEditorContext) -> void
```

### _build_categories

```gdscript
func _build_categories(ctx: ScenarioEditorContext) -> void
```

### _set_faction

```gdscript
func _set_faction(ctx: ScenarioEditorContext, aff) -> void
```

### _setup_tree

```gdscript
func _setup_tree(ctx: ScenarioEditorContext) -> void
```

### _on_tree_item

```gdscript
func _on_tree_item(ctx: ScenarioEditorContext) -> void
```

### _refresh

```gdscript
func _refresh(ctx: ScenarioEditorContext) -> void
```

### _setup_unit_create

```gdscript
func _setup_unit_create(ctx: ScenarioEditorContext)
```

### _on_create_pressed

```gdscript
func _on_create_pressed(ctx: ScenarioEditorContext) -> void
```

### _on_unit_saved

```gdscript
func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void
```

### _on_dialog_closed

```gdscript
func _on_dialog_closed(ctx: ScenarioEditorContext) -> void
```

Called when dialog is closed without saving

### _get_selected_unit

```gdscript
func _get_selected_unit(ctx: ScenarioEditorContext) -> UnitData
```

Get the UnitData from the current selection.

### _used_unit_ids

```gdscript
func _used_unit_ids(ctx: ScenarioEditorContext) -> Dictionary
```

### _update_button_text

```gdscript
func _update_button_text(ctx: ScenarioEditorContext) -> void
```

Update the create/edit button text based on current selection

### _deselect_unit

```gdscript
func _deselect_unit(ctx: ScenarioEditorContext) -> void
```

Deselect the currently selected unit in the tree

### _cancel_active_tool

```gdscript
func _cancel_active_tool(ctx: ScenarioEditorContext) -> void
```

Cancel the active tool if one is running

## Member Data Documentation

### all_units

```gdscript
var all_units: Array[UnitData]
```

### unit_categories

```gdscript
var unit_categories: Array[UnitCategoryData]
```

### selected_category

```gdscript
var selected_category: UnitCategoryData
```
