extends Node
# Provide a custom logger service which can be displayed in the debug menu.

## Emits on a new log line
signal line(text: String, level: LogLevel)

## Log Level for message
enum LogLevel { LOG, INFO, ERROR, WARNING, DEBUG, TRACE }

var _tap: LogTap
var _project_level: LogLevel = ProjectSettings.get_setting("debug/settings/stdout/log_level")


func _enter_tree() -> void:
	_tap = LogTap.new()
	_tap.message.connect(_captured_log)
	OS.add_logger(_tap)


func _exit_tree() -> void:
	if _tap:
		OS.remove_logger(_tap)


## Log generic message
func _captured_log(_level, msg: String):
	var fmt_msg := _fmt_msg(msg, LogLevel.LOG)
	print_rich(fmt_msg)
	emit_signal("line", fmt_msg, LogLevel.LOG)


## Log INFO level rich message
func info(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.INFO, src)
	emit_signal("line", fmt_msg, LogLevel.INFO)
	if _project_level >= LogLevel.INFO:
		print_rich(fmt_msg)


## Log WARNING level rich message
func warning(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.WARNING, src)
	emit_signal("line", fmt_msg, LogLevel.WARNING)
	if _project_level >= LogLevel.WARNING:
		print_rich(fmt_msg)


## Log ERROR level rich message
func error(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.ERROR, src)
	emit_signal("line", fmt_msg, LogLevel.ERROR)
	if _project_level >= LogLevel.ERROR:
		print_rich(fmt_msg)


## Log a DEBUG level rich message.
## [param msg] Message to log.
## [param src] source of log message e.g. "LogService.gd:58"
func debug(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.DEBUG, src)
	emit_signal("line", fmt_msg, LogLevel.DEBUG)
	if _project_level >= LogLevel.DEBUG:
		print_rich(fmt_msg)
		
## Log TRACE level rich message
func trace(msg: String, src := ""):
	var fmt_msg := _fmt_msg(msg, LogLevel.TRACE, src)
	emit_signal("line", fmt_msg, LogLevel.TRACE)
	if _project_level >= LogLevel.TRACE:
		print_rich(fmt_msg)


## get formatted time
func _get_fmt_time() -> String:
	var time := Time.get_datetime_dict_from_system()
	return "%02d:%02d:%02d" % [time.hour, time.minute, time.second]


## Get a formatted log message
func _fmt_msg(msg: String, lvl: LogLevel, src := "") -> String:
	var fmt_time = "[bgcolor=#3b3b3f][color=white] %s [/color][/bgcolor]" % _get_fmt_time()
	var fmt_lvl = _fmt_level(lvl)
	var fmt_src = " [color=#525457]%s[/color]" % src if src != "" else ""
	return "%s%s [color=white]%s[/color]%s" % [fmt_time, fmt_lvl, msg, fmt_src]


## Get formatted level string
func _fmt_level(lvl: LogLevel) -> String:
	match lvl:
		LogLevel.LOG:
			return "[bgcolor=white][color=black]   LOG   [/color][/bgcolor]"
		LogLevel.INFO:
			return "[bgcolor=#399b9c][color=black]  INFO   [/color][/bgcolor]"
		LogLevel.WARNING:
			return "[bgcolor=#dac663][color=black] WARNING [/color][/bgcolor]"
		LogLevel.ERROR:
			return "[bgcolor=#f8736d][color=black]  ERROR  [/color][/bgcolor]"
		LogLevel.DEBUG:
			return "[bgcolor=#d26aca][color=black]  DEBUG  [/color][/bgcolor]"
		LogLevel.TRACE:
			return "[bgcolor=#a78bb9][color=black]  TRACE  [/color][/bgcolor]"
	return ""
