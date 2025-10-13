# AmmoRearmPanel::_update_depot_label Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 247–253)</br>
*Belongs to:* [AmmoRearmPanel](../../AmmoRearmPanel.md)

**Signature**

```gdscript
func _update_depot_label() -> void
```

## Source

```gdscript
func _update_depot_label() -> void:
	var parts: Array[String] = []
	for t in _depot.keys():
		parts.append("%s %d" % [str(t), int(_depot[t])])
	_lbl_depot.text = "Depot: " + ", ".join(parts)
```
