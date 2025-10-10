# FuelTest::_on_topup Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 294–299)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _on_topup() -> void
```

## Source

```gdscript
func _on_topup() -> void:
	if tk.unit.throughput is Dictionary:
		var cur: int = int(tk.unit.throughput.get("fuel", 0))
		tk.unit.throughput["fuel"] = cur + 100
```
