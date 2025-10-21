# AmmoTest::_update_link_status Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 209–217)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _update_link_status() -> void
```

## Source

```gdscript
func _update_link_status() -> void:
	var d: float = _pos_shooter.distance_to(_pos_logi)
	var in_range: bool = d <= max(logi.supply_transfer_radius_m, 0.0)
	var status := "IN RANGE" if in_range else "OUT OF RANGE"
	_lbl_link.text = (
		"Link: distance=%.1fm  (radius=%.1fm)  %s" % [d, logi.supply_transfer_radius_m, status]
	)
```
