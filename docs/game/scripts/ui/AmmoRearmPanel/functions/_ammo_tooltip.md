# AmmoRearmPanel::_ammo_tooltip Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 254–266)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _ammo_tooltip(u: UnitData) -> String
```

## Source

```gdscript
func _ammo_tooltip(u: UnitData) -> String:
	var lines: Array[String] = []
	for t in u.ammunition.keys():
		var cur: int = int(u.state_ammunition.get(t, 0))
		var cap: int = int(u.ammunition[t])
		lines.append("%s: %d/%d" % [str(t), cur, cap])
	if u.throughput is Dictionary and not u.throughput.is_empty():
		lines.append("[payload]")
		for t in u.throughput.keys():
			lines.append("%s: %d" % [str(t), int(u.throughput[t])])
	return "\n".join(lines)
```
