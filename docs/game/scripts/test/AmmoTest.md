# AmmoTest Class Reference

*File:* `scripts/test/AmmoTest.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](AmmoTest/functions/_ready.md)
- [`func _physics_process(delta: float) -> void`](AmmoTest/functions/_physics_process.md)
- [`func _enable_log() -> void`](AmmoTest/functions/_enable_log.md)
- [`func _spawn_units() -> void`](AmmoTest/functions/_spawn_units.md)
- [`func _wire_ui() -> void`](AmmoTest/functions/_wire_ui.md)
- [`func _on_fire_once() -> void`](AmmoTest/functions/_on_fire_once.md)
- [`func _on_toggle_auto() -> void`](AmmoTest/functions/_on_toggle_auto.md)
- [`func _on_move_near() -> void`](AmmoTest/functions/_on_move_near.md)
- [`func _on_move_far() -> void`](AmmoTest/functions/_on_move_far.md)
- [`func _on_reset() -> void`](AmmoTest/functions/_on_reset.md)
- [`func _update_hud() -> void`](AmmoTest/functions/_update_hud.md)
- [`func _update_link_status() -> void`](AmmoTest/functions/_update_link_status.md)
- [`func _print(line: String) -> void`](AmmoTest/functions/_print.md)
- [`func _scroll_log_bottom() -> void`](AmmoTest/functions/_scroll_log_bottom.md)
- [`func _embed_rearm_panel() -> void`](AmmoTest/functions/_embed_rearm_panel.md)
- [`func _on_rearm_committed() -> void`](AmmoTest/functions/_on_rearm_committed.md)
- [`func _save_campaign_state() -> void`](AmmoTest/functions/_save_campaign_state.md)

## Public Attributes

- `AmmoSystem ammo`
- `CombatAdapter adapter`
- `AmmoProfile profile`
- `UnitData shooter`
- `UnitData logi`
- `Vector3 _pos_shooter`
- `Vector3 _pos_logi`
- `Timer _print_tick`
- `AmmoRearmPanel _rearm_panel`
- `Label _lbl_shooter`
- `Label _lbl_logi`
- `Label _lbl_link`
- `RichTextLabel _log`
- `Button _btn_fire`
- `Button _btn_auto`
- `Button _btn_near`
- `Button _btn_far`
- `Button _btn_reset`
- `Timer _fire_timer`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _physics_process

```gdscript
func _physics_process(delta: float) -> void
```

### _enable_log

```gdscript
func _enable_log() -> void
```

### _spawn_units

```gdscript
func _spawn_units() -> void
```

### _wire_ui

```gdscript
func _wire_ui() -> void
```

### _on_fire_once

```gdscript
func _on_fire_once() -> void
```

### _on_toggle_auto

```gdscript
func _on_toggle_auto() -> void
```

### _on_move_near

```gdscript
func _on_move_near() -> void
```

### _on_move_far

```gdscript
func _on_move_far() -> void
```

### _on_reset

```gdscript
func _on_reset() -> void
```

### _update_hud

```gdscript
func _update_hud() -> void
```

### _update_link_status

```gdscript
func _update_link_status() -> void
```

### _print

```gdscript
func _print(line: String) -> void
```

### _scroll_log_bottom

```gdscript
func _scroll_log_bottom() -> void
```

### _embed_rearm_panel

```gdscript
func _embed_rearm_panel() -> void
```

### _on_rearm_committed

```gdscript
func _on_rearm_committed() -> void
```

### _save_campaign_state

```gdscript
func _save_campaign_state() -> void
```

## Member Data Documentation

### ammo

```gdscript
var ammo: AmmoSystem
```

### adapter

```gdscript
var adapter: CombatAdapter
```

### profile

```gdscript
var profile: AmmoProfile
```

### shooter

```gdscript
var shooter: UnitData
```

### logi

```gdscript
var logi: UnitData
```

### _pos_shooter

```gdscript
var _pos_shooter: Vector3
```

### _pos_logi

```gdscript
var _pos_logi: Vector3
```

### _print_tick

```gdscript
var _print_tick: Timer
```

### _rearm_panel

```gdscript
var _rearm_panel: AmmoRearmPanel
```

### _lbl_shooter

```gdscript
var _lbl_shooter: Label
```

### _lbl_logi

```gdscript
var _lbl_logi: Label
```

### _lbl_link

```gdscript
var _lbl_link: Label
```

### _log

```gdscript
var _log: RichTextLabel
```

### _btn_fire

```gdscript
var _btn_fire: Button
```

### _btn_auto

```gdscript
var _btn_auto: Button
```

### _btn_near

```gdscript
var _btn_near: Button
```

### _btn_far

```gdscript
var _btn_far: Button
```

### _btn_reset

```gdscript
var _btn_reset: Button
```

### _fire_timer

```gdscript
var _fire_timer: Timer
```
