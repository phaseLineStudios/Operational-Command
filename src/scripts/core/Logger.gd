extends Logger
class_name LogTap

## Emits on a new log message
signal message(level: int, text: String)

## Log a message
func _log_message(msg, _err):
	if msg.begins_with("[48"): 
		return
	emit_signal("message", 0, str(msg.trim_suffix("\n")))

## Log a error message
func _log_error(_func, _file, _line, _code, msg, _notif, _err, _back):
	emit_signal("message", 0, "[ERROR] " + str(msg.trim_suffix("\n")))
