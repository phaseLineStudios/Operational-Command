# LogTap Class Reference

*File:* `scripts/core/Logger.gd`
*Class name:* `LogTap`
*Inherits:* `Logger`

## Synopsis

```gdscript
class_name LogTap
extends Logger
```

## Public Member Functions

- [`func _log_message(msg, _err)`](LogTap/functions/_log_message.md) — Log a message

## Signals

- `signal message(level: int, text: String)` — Emits on a new log message

## Member Function Documentation

### _log_message

```gdscript
func _log_message(msg, _err)
```

Log a message

## Signal Documentation

### message

```gdscript
signal message(level: int, text: String)
```

Emits on a new log message
