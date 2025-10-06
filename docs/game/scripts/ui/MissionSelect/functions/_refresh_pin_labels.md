# MissionSelect::_refresh_pin_labels Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 174–185)</br>
*Belongs to:* [MissionSelect](../MissionSelect.md)

**Signature**

```gdscript
func _refresh_pin_labels() -> void
```

## Description

Refresh label visibility on all pins.

## Source

```gdscript
func _refresh_pin_labels() -> void:
	for node in _pins_layer.get_children():
		if node is BaseButton:
			if show_pin_labels:
				var title: String = node.get_meta("title", "")
				if title != "":
					_attach_pin_label(node, title)
			else:
				if node.has_node("PinLabel"):
					node.get_node("PinLabel").queue_free()
```
