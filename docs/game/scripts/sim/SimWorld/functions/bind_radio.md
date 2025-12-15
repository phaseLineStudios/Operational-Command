# SimWorld::bind_radio Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 471–491)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func bind_radio(radio: Radio, parser: Node) -> void
```

- **radio**: Radio node emitting `radio_result`.
- **parser**: Parser node emitting `parsed(Array)` and `parse_error(String)`.

## Description

Bind Radio and Parser so voice results are queued automatically.

## Source

```gdscript
func bind_radio(radio: Radio, parser: Node) -> void:
	if radio and not radio.radio_result.is_connected(parser.parse):
		radio.radio_result.connect(parser.parse)
	if parser and not parser.parsed.is_connected(func(orders): queue_orders(orders)):
		parser.parsed.connect(func(orders): queue_orders(orders))
	if (
		parser
		and not parser.parse_error.is_connected(
			func(msg): emit_signal("radio_message", "error", msg)
		)
	):
		parser.parse_error.connect(func(msg): emit_signal("radio_message", "error", msg))

	# Bind radio to trigger engine for raw command matching
	if trigger_engine and radio:
		trigger_engine.bind_radio(radio)
		# Also listen for custom commands with trigger IDs
		if not radio.radio_raw_command.is_connected(_on_radio_command_for_triggers):
			radio.radio_raw_command.connect(_on_radio_command_for_triggers)
```
