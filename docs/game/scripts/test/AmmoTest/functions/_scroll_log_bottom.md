# AmmoTest::_scroll_log_bottom Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 224–228)</br>
*Belongs to:* [AmmoTest](../AmmoTest.md)

**Signature**

```gdscript
func _scroll_log_bottom() -> void
```

## Source

```gdscript
func _scroll_log_bottom() -> void:
	if _log.scroll_active:
		_log.scroll_to_line(_log.get_line_count() - 1)
```
