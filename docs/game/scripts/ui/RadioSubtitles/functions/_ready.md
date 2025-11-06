# RadioSubtitles::_ready Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 23–33)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_tables = NARules.get_parser_tables()
	visible = false

	# Create hide timer
	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(_hide_timer)
```
