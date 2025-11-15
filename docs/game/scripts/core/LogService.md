# LogService Class Reference

*File:* `scripts/core/LogService.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Public Member Functions

- [`func _enter_tree() -> void`](LogService/functions/_enter_tree.md)
- [`func _exit_tree() -> void`](LogService/functions/_exit_tree.md)
- [`func _captured_log(_level, msg: String)`](LogService/functions/_captured_log.md) — Log generic message
- [`func info(msg: String, src := "")`](LogService/functions/info.md) — Log INFO level rich message
- [`func warning(msg: String, src := "")`](LogService/functions/warning.md) — Log WARNING level rich message
- [`func error(msg: String, src := "")`](LogService/functions/error.md) — Log ERROR level rich message
- [`func debug(msg: String, src := "")`](LogService/functions/debug.md) — Log a DEBUG level rich message.
- [`func trace(msg: String, src := "")`](LogService/functions/trace.md) — Log TRACE level rich message
- [`func _get_fmt_time() -> String`](LogService/functions/_get_fmt_time.md) — get formatted time
- [`func _fmt_msg(msg: String, lvl: LogLevel, src := "") -> String`](LogService/functions/_fmt_msg.md) — Get a formatted log message
- [`func _fmt_level(lvl: LogLevel) -> String`](LogService/functions/_fmt_level.md) — Get formatted level string

## Public Attributes

- `LogTap _tap`
- `LogLevel _project_level`

## Signals

- `signal line(text: String, level: LogLevel)` — Emits on a new log line

## Enumerations

- `enum LogLevel` — Log Level for message

## Member Function Documentation

### _enter_tree

```gdscript
func _enter_tree() -> void
```

### _exit_tree

```gdscript
func _exit_tree() -> void
```

### _captured_log

```gdscript
func _captured_log(_level, msg: String)
```

Log generic message

### info

```gdscript
func info(msg: String, src := "")
```

Log INFO level rich message

### warning

```gdscript
func warning(msg: String, src := "")
```

Log WARNING level rich message

### error

```gdscript
func error(msg: String, src := "")
```

Log ERROR level rich message

### debug

```gdscript
func debug(msg: String, src := "")
```

Log a DEBUG level rich message.
`msg` Message to log.
`src` source of log message e.g. "LogService.gd:58"

### trace

```gdscript
func trace(msg: String, src := "")
```

Log TRACE level rich message

### _get_fmt_time

```gdscript
func _get_fmt_time() -> String
```

get formatted time

### _fmt_msg

```gdscript
func _fmt_msg(msg: String, lvl: LogLevel, src := "") -> String
```

Get a formatted log message

### _fmt_level

```gdscript
func _fmt_level(lvl: LogLevel) -> String
```

Get formatted level string

## Member Data Documentation

### _tap

```gdscript
var _tap: LogTap
```

### _project_level

```gdscript
var _project_level: LogLevel
```

## Signal Documentation

### line

```gdscript
signal line(text: String, level: LogLevel)
```

Emits on a new log line

## Enumeration Type Documentation

### LogLevel

```gdscript
enum LogLevel
```

Log Level for message
