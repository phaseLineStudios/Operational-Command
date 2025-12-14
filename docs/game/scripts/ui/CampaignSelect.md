# CampaignSelect Class Reference

*File:* `scripts/ui/CampaignSelect.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Campaign Select scene controller.

## Detailed Description

Wires the campaign list, details panel, and action buttons.
Flow:
1) User selects a campaign from `member list_campaigns`.
2) Details placeholder updates and action buttons become visible.
3) "Create new save" creates/selects a save and advances to Mission Select.

Path to Mission Select Scene

Path to Main Menu Scene

## Public Member Functions

- [`func _ready() -> void`](CampaignSelect/functions/_ready.md) — Init UI, populate list, connect signals.
- [`func _connect_signals() -> void`](CampaignSelect/functions/_connect_signals.md) — Connects UI signals to handlers.
- [`func _populate_campaigns() -> void`](CampaignSelect/functions/_populate_campaigns.md) — Fill ItemList from ContentDB.
- [`func _on_campaign_selected(index: int) -> void`](CampaignSelect/functions/_on_campaign_selected.md) — Handle campaign selection; update details + show actions.
- [`func _update_details(campaign: CampaignData) -> void`](CampaignSelect/functions/_update_details.md) — Placeholder details update (to be replaced later).
- [`func _update_action_buttons() -> void`](CampaignSelect/functions/_update_action_buttons.md) — Update action button visibility and states based on existing saves.
- [`func _on_new_save_pressed() -> void`](CampaignSelect/functions/_on_new_save_pressed.md) — Create/select new save and go to Mission Select.
- [`func _on_new_save_created() -> void`](CampaignSelect/functions/_on_new_save_created.md) — Create new save with entered name
- [`func _on_new_save_cancelled() -> void`](CampaignSelect/functions/_on_new_save_cancelled.md) — Called when new save is cancelled
- [`func _on_continue_last_pressed() -> void`](CampaignSelect/functions/_on_continue_last_pressed.md) — resolves last save for the current campaign (if any).
- [`func _on_select_save_pressed() -> void`](CampaignSelect/functions/_on_select_save_pressed.md) — open a save picker filtered to the current campaign.
- [`func _show_save_picker(saves: Array[CampaignSave]) -> void`](CampaignSelect/functions/_show_save_picker.md) — Show save picker dialog.
- [`func _select_save_load() -> void`](CampaignSelect/functions/_select_save_load.md) — Load selected save
- [`func _select_save_delete() -> void`](CampaignSelect/functions/_select_save_delete.md) — Handle deletion of saves
- [`func _delete_save(save_id: String) -> void`](CampaignSelect/functions/_delete_save.md) — Delete save by save id
- [`func _select_save_close() -> void`](CampaignSelect/functions/_select_save_close.md) — Handle closing of select save dialog
- [`func _on_back_pressed() -> void`](CampaignSelect/functions/_on_back_pressed.md) — Back to main menu.

## Public Attributes

- `Array[CampaignData] _campaign_rows`
- `CampaignData _selected_campaign`
- `ItemList list_campaigns`
- `PanelContainer details_root`
- `OCMenuButton btn_continue_last`
- `OCMenuButton btn_select_save`
- `OCMenuButton btn_new_save`
- `OCMenuButton btn_back`
- `TextureRect campaign_poster`
- `RichTextLabel campaign_desc`
- `OCMenuContentLoad select_save`
- `OCMenuWindow new_save`
- `LineEdit new_save_name`
- `OCMenuButton delete_save`
- `OCMenuConfirmation confirm_dialog`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Init UI, populate list, connect signals.

### _connect_signals

```gdscript
func _connect_signals() -> void
```

Connects UI signals to handlers.

### _populate_campaigns

```gdscript
func _populate_campaigns() -> void
```

Fill ItemList from ContentDB.

### _on_campaign_selected

```gdscript
func _on_campaign_selected(index: int) -> void
```

Handle campaign selection; update details + show actions.

### _update_details

```gdscript
func _update_details(campaign: CampaignData) -> void
```

Placeholder details update (to be replaced later).

### _update_action_buttons

```gdscript
func _update_action_buttons() -> void
```

Update action button visibility and states based on existing saves.

### _on_new_save_pressed

```gdscript
func _on_new_save_pressed() -> void
```

Create/select new save and go to Mission Select.

### _on_new_save_created

```gdscript
func _on_new_save_created() -> void
```

Create new save with entered name

### _on_new_save_cancelled

```gdscript
func _on_new_save_cancelled() -> void
```

Called when new save is cancelled

### _on_continue_last_pressed

```gdscript
func _on_continue_last_pressed() -> void
```

resolves last save for the current campaign (if any).

### _on_select_save_pressed

```gdscript
func _on_select_save_pressed() -> void
```

open a save picker filtered to the current campaign.

### _show_save_picker

```gdscript
func _show_save_picker(saves: Array[CampaignSave]) -> void
```

Show save picker dialog.

### _select_save_load

```gdscript
func _select_save_load() -> void
```

Load selected save

### _select_save_delete

```gdscript
func _select_save_delete() -> void
```

Handle deletion of saves

### _delete_save

```gdscript
func _delete_save(save_id: String) -> void
```

Delete save by save id

### _select_save_close

```gdscript
func _select_save_close() -> void
```

Handle closing of select save dialog

### _on_back_pressed

```gdscript
func _on_back_pressed() -> void
```

Back to main menu.

## Member Data Documentation

### _campaign_rows

```gdscript
var _campaign_rows: Array[CampaignData]
```

### _selected_campaign

```gdscript
var _selected_campaign: CampaignData
```

### list_campaigns

```gdscript
var list_campaigns: ItemList
```

### details_root

```gdscript
var details_root: PanelContainer
```

### btn_continue_last

```gdscript
var btn_continue_last: OCMenuButton
```

### btn_select_save

```gdscript
var btn_select_save: OCMenuButton
```

### btn_new_save

```gdscript
var btn_new_save: OCMenuButton
```

### btn_back

```gdscript
var btn_back: OCMenuButton
```

### campaign_poster

```gdscript
var campaign_poster: TextureRect
```

### campaign_desc

```gdscript
var campaign_desc: RichTextLabel
```

### select_save

```gdscript
var select_save: OCMenuContentLoad
```

### new_save

```gdscript
var new_save: OCMenuWindow
```

### new_save_name

```gdscript
var new_save_name: LineEdit
```

### delete_save

```gdscript
var delete_save: OCMenuButton
```

### confirm_dialog

```gdscript
var confirm_dialog: OCMenuConfirmation
```
