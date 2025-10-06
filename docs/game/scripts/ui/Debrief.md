# Debrief Class Reference

*File:* `scripts/ui/Debrief.gd`
*Class name:* `Debrief`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name Debrief
extends Control
```

## Brief

Debrief UI control.

## Detailed Description

Renders a mission debrief screen with a left column (objectives, score, casualties),
a right column (unit performance table and commendation assignment), and a bottom bar
(Retry and Continue buttons with a dynamic title).

Public API for filling the UI from game logic:
- set_mission_name(), set_outcome(), set_objectives_results()
- set_score(), set_casualties(), set_units()
- set_recipients_from_units(), set_commendation_options()
- populate_from_dict()

Emits signals so the parent scene can react:
- continue_requested(payload: Dictionary)
- retry_requested(payload: Dictionary)
- commendation_assigned(commendation: String, recipient: String)

All set_* methods are idempotent. The layout adjusts the commendation panel height
so the bottom of the Units panel aligns with the bottom of the Casualties panel.

Minimum vertical size reserved for the commendation panel to keep controls usable.

Backing fields for the payload collected on Continue and Retry.
"score" and "casualties" mirror the structure accepted by the set_* methods.

## Public Member Functions

- [`func _ready() -> void`](Debrief/functions/_ready.md) — Initializes node references, connects button handlers, prepares the Units tree,
draws the initial title, and aligns the right split after the first layout pass.
- [`func _notification(what)`](Debrief/functions/_notification.md) — Reapplies alignment when the control is resized by the parent or user.
- [`func set_mission_name(mission_name: String) -> void`](Debrief/functions/set_mission_name.md) — Sets the mission name and refreshes the title label.
- [`func set_outcome(outcome: String) -> void`](Debrief/functions/set_outcome.md) — Sets the outcome label text and refreshes the title label.
- [`func set_objectives_results(results: Array) -> void`](Debrief/functions/set_objectives_results.md) — Populates the objectives list with checkmarks and crosses.
- [`func set_score(score: Dictionary) -> void`](Debrief/functions/set_score.md) — Sets base, bonus, penalty, and total score fields.
- [`func set_casualties(c: Dictionary) -> void`](Debrief/functions/set_casualties.md) — Sets friendly and enemy casualty figures and updates the RichText labels.
- [`func set_units(units: Array) -> void`](Debrief/functions/set_units.md) — Populates the Units tree with per-unit rows.
- [`func set_recipients_from_units() -> void`](Debrief/functions/set_recipients_from_units.md) — Copies the unit names currently displayed into the Recipient dropdown.
- [`func set_commendation_options(options: Array) -> void`](Debrief/functions/set_commendation_options.md) — Sets the available commendation names in the Award dropdown.
- [`func populate_from_dict(d: Dictionary) -> void`](Debrief/functions/populate_from_dict.md) — Populates the entire UI from a single dictionary.
- [`func get_selected_commendation() -> String`](Debrief/functions/get_selected_commendation.md) — Returns the currently selected award, or an empty string if none is selected.
- [`func get_selected_recipient() -> String`](Debrief/functions/get_selected_recipient.md) — Returns the selected recipient name, or an empty string if none is selected.
- [`func _on_assign_pressed() -> void`](Debrief/functions/_on_assign_pressed.md) — Emits "commendation_assigned" only when both selection fields are non-empty.
- [`func _on_continue_pressed() -> void`](Debrief/functions/_on_continue_pressed.md) — Emits "continue_requested" with a snapshot of the current debrief state.
- [`func _on_retry_pressed() -> void`](Debrief/functions/_on_retry_pressed.md) — Emits "retry_requested" with the same payload format as continue.
- [`func _collect_payload() -> Dictionary`](Debrief/functions/_collect_payload.md) — Collects a snapshot of all user-visible state for higher-level flow management.
- [`func _update_title() -> void`](Debrief/functions/_update_title.md) — Keeps the bottom title in sync with the latest mission and outcome.
- [`func _assert_nodes() -> void`](Debrief/functions/_assert_nodes.md) — Emits editor warnings if required scene nodes are missing.
- [`func _init_units_tree_columns() -> void`](Debrief/functions/_init_units_tree_columns.md) — Applies headers and column sizing rules to the Units tree.
- [`func _request_align() -> void`](Debrief/functions/_request_align.md) — Defers alignment one frame so container sizes update before measuring.
- [`func _align_right_split() -> void`](Debrief/functions/_align_right_split.md) — Computes the required commendation panel height so the bottom of the Units area
aligns with the bottom of the Casualties panel, without shrinking below
MIN_COMMEND_PANEL_HEIGHT.

## Public Attributes

- `Label _title`
- `Button _btn_retry`
- `Button _btn_continue`
- `ItemList _objectives_list`
- `Label _score_base`
- `Label _score_bonus`
- `Label _score_penalty`
- `Label _score_total`
- `RichTextLabel _cas_friend`
- `RichTextLabel _cas_enemy`
- `Tree _units_tree`
- `OptionButton _recipient_dd`
- `OptionButton _award_dd`
- `Button _assign_btn`
- `VBoxContainer _left_col`
- `VBoxContainer _right_col`
- `Panel _left_objectives_panel`
- `Panel _left_score_panel`
- `Panel _left_casualties_panel`
- `Panel _right_commend_panel`

## Signals

- `signal continue_requested(payload: Dictionary)` — Emitted when the user continues the flow.
- `signal retry_requested(payload: Dictionary)` — Emitted when the user requests a retry.
- `signal commendation_assigned(commendation: String, recipient: String)` — Emitted when a commendation is assigned to a recipient.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initializes node references, connects button handlers, prepares the Units tree,
draws the initial title, and aligns the right split after the first layout pass.

### _notification

```gdscript
func _notification(what)
```

Reapplies alignment when the control is resized by the parent or user.

### set_mission_name

```gdscript
func set_mission_name(mission_name: String) -> void
```

Sets the mission name and refreshes the title label.

### set_outcome

```gdscript
func set_outcome(outcome: String) -> void
```

Sets the outcome label text and refreshes the title label.

### set_objectives_results

```gdscript
func set_objectives_results(results: Array) -> void
```

Populates the objectives list with checkmarks and crosses.
Accepted per-item shapes:
- String: "Seize objective"
- Dictionary: {"title": String, "completed": bool}
- Dictionary: {"objective": Object|Dictionary, "completed": bool}
For nested objects or dictionaries, "title" is preferred, then "name".

### set_score

```gdscript
func set_score(score: Dictionary) -> void
```

Sets base, bonus, penalty, and total score fields.
"total" is derived as base + bonus - penalty if omitted.

### set_casualties

```gdscript
func set_casualties(c: Dictionary) -> void
```

Sets friendly and enemy casualty figures and updates the RichText labels.
Missing values default to 0.
Shape:
{
"friendly": {"kia": int, "wia": int, "vehicles": int},
"enemy":    {"kia": int, "wia": int, "vehicles": int}
}

### set_units

```gdscript
func set_units(units: Array) -> void
```

Populates the Units tree with per-unit rows.
Accepted per-row shapes:
- {"name": String, "kills"?: int, "wia"?: int, "kia"?: int, "xp"?: int, "status"?: String}
- {"unit": Object with "title" or "name", same optional stats as above}

### set_recipients_from_units

```gdscript
func set_recipients_from_units() -> void
```

Copies the unit names currently displayed into the Recipient dropdown.

### set_commendation_options

```gdscript
func set_commendation_options(options: Array) -> void
```

Sets the available commendation names in the Award dropdown.

### populate_from_dict

```gdscript
func populate_from_dict(d: Dictionary) -> void
```

Populates the entire UI from a single dictionary.
Keys:
{
"mission_name": String,
"outcome": String,
"objectives": Array,      see set_objectives_results()
"score": Dictionary,      see set_score()
"casualties": Dictionary, see set_casualties()
"units": Array,           see set_units()
"commendations": Array    list of award names
}

### get_selected_commendation

```gdscript
func get_selected_commendation() -> String
```

Returns the currently selected award, or an empty string if none is selected.

### get_selected_recipient

```gdscript
func get_selected_recipient() -> String
```

Returns the selected recipient name, or an empty string if none is selected.

### _on_assign_pressed

```gdscript
func _on_assign_pressed() -> void
```

Emits "commendation_assigned" only when both selection fields are non-empty.

### _on_continue_pressed

```gdscript
func _on_continue_pressed() -> void
```

Emits "continue_requested" with a snapshot of the current debrief state.

### _on_retry_pressed

```gdscript
func _on_retry_pressed() -> void
```

Emits "retry_requested" with the same payload format as continue.

### _collect_payload

```gdscript
func _collect_payload() -> Dictionary
```

Collects a snapshot of all user-visible state for higher-level flow management.

### _update_title

```gdscript
func _update_title() -> void
```

Keeps the bottom title in sync with the latest mission and outcome.

### _assert_nodes

```gdscript
func _assert_nodes() -> void
```

Emits editor warnings if required scene nodes are missing.

### _init_units_tree_columns

```gdscript
func _init_units_tree_columns() -> void
```

Applies headers and column sizing rules to the Units tree.
Safe to call multiple times.

### _request_align

```gdscript
func _request_align() -> void
```

Defers alignment one frame so container sizes update before measuring.

### _align_right_split

```gdscript
func _align_right_split() -> void
```

Computes the required commendation panel height so the bottom of the Units area
aligns with the bottom of the Casualties panel, without shrinking below
MIN_COMMEND_PANEL_HEIGHT.

## Member Data Documentation

### _title

```gdscript
var _title: Label
```

### _btn_retry

```gdscript
var _btn_retry: Button
```

### _btn_continue

```gdscript
var _btn_continue: Button
```

### _objectives_list

```gdscript
var _objectives_list: ItemList
```

### _score_base

```gdscript
var _score_base: Label
```

### _score_bonus

```gdscript
var _score_bonus: Label
```

### _score_penalty

```gdscript
var _score_penalty: Label
```

### _score_total

```gdscript
var _score_total: Label
```

### _cas_friend

```gdscript
var _cas_friend: RichTextLabel
```

### _cas_enemy

```gdscript
var _cas_enemy: RichTextLabel
```

### _units_tree

```gdscript
var _units_tree: Tree
```

### _recipient_dd

```gdscript
var _recipient_dd: OptionButton
```

### _award_dd

```gdscript
var _award_dd: OptionButton
```

### _assign_btn

```gdscript
var _assign_btn: Button
```

### _left_col

```gdscript
var _left_col: VBoxContainer
```

### _right_col

```gdscript
var _right_col: VBoxContainer
```

### _left_objectives_panel

```gdscript
var _left_objectives_panel: Panel
```

### _left_score_panel

```gdscript
var _left_score_panel: Panel
```

### _left_casualties_panel

```gdscript
var _left_casualties_panel: Panel
```

### _right_commend_panel

```gdscript
var _right_commend_panel: Panel
```

## Signal Documentation

### continue_requested

```gdscript
signal continue_requested(payload: Dictionary)
```

Emitted when the user continues the flow. Carries a snapshot payload.

### retry_requested

```gdscript
signal retry_requested(payload: Dictionary)
```

Emitted when the user requests a retry. Carries the same payload as continue.

### commendation_assigned

```gdscript
signal commendation_assigned(commendation: String, recipient: String)
```

Emitted when a commendation is assigned to a recipient.
