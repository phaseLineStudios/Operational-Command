# NotificationBanner Class Reference

*File:* `scripts/ui/NotificationBanner.gd`
*Class name:* `NotificationBanner`
*Inherits:* `PanelContainer`

## Synopsis

```gdscript
class_name NotificationBanner
extends PanelContainer
```

## Brief

Notification banner for the scenario editor.

## Detailed Description

Displays temporary notifications at the top of the viewport with different
styles for success, failure, and general messages.

Colors for different notification types

Sound for success notification

Internal method to show notification with specified type.

## Public Member Functions

- [`func _ready() -> void`](NotificationBanner/functions/_ready.md)
- [`func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](NotificationBanner/functions/success_notification.md) — Show a success notification with green background.
- [`func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](NotificationBanner/functions/failed_notification.md) — Show a failure notification with red background.
- [`func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](NotificationBanner/functions/generic_notification.md) — Show a normal notification with gray background.
- [`func hide_notification() -> void`](NotificationBanner/functions/hide_notification.md) — Hide notification (called by timer or manually).
- [`func _on_timer_timeout() -> void`](NotificationBanner/functions/_on_timer_timeout.md) — Handle timer timeout.

## Public Attributes

- `StyleBoxFlat _panel_style`
- `Label _label`
- `Timer _timer`
- `AudioStreamPlayer _audio`

## Enumerations

- `enum NotificationType` — Notification type

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### success_notification

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a success notification with green background.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play success sound (default true).

### failed_notification

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a failure notification with red background.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play failure sound (default true).

### generic_notification

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a normal notification with gray background.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play notification sound (default true).

### hide_notification

```gdscript
func hide_notification() -> void
```

Hide notification (called by timer or manually).

### _on_timer_timeout

```gdscript
func _on_timer_timeout() -> void
```

Handle timer timeout.

## Member Data Documentation

### _panel_style

```gdscript
var _panel_style: StyleBoxFlat
```

### _label

```gdscript
var _label: Label
```

### _timer

```gdscript
var _timer: Timer
```

### _audio

```gdscript
var _audio: AudioStreamPlayer
```

## Enumeration Type Documentation

### NotificationType

```gdscript
enum NotificationType
```

Notification type
