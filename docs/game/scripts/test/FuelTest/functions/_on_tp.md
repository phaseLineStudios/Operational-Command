# FuelTest::_on_tp Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 290–293)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _on_tp() -> void
```

## Source

```gdscript
func _on_tp() -> void:
	tk.position_m = rx.position_m + Vector2(min(TK_RADIUS * 0.5, 10.0), 0.0)
```
