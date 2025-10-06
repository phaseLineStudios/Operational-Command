# AmmoTest::_print Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 218–223)</br>
*Belongs to:* [AmmoTest](../AmmoTest.md)

**Signature**

```gdscript
func _print(line: String) -> void
```

## Source

```gdscript
func _print(line: String) -> void:
	print(line)  # Godot output
	_log.append_text(line + "\n")
	call_deferred("_scroll_log_bottom")
```
