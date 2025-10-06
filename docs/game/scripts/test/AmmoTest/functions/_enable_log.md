# AmmoTest::_enable_log Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 110–116)</br>
*Belongs to:* [AmmoTest](../AmmoTest.md)

**Signature**

```gdscript
func _enable_log() -> void
```

## Source

```gdscript
func _enable_log() -> void:
	_log.custom_minimum_size = Vector2(0, 180)
	_log.scroll_active = true
	_log.scroll_following = true
	_log.autowrap_mode = TextServer.AUTOWRAP_WORD
```
