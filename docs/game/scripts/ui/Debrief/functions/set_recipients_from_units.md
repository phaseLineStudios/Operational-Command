# Debrief::set_recipients_from_units Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 246–255)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_recipients_from_units() -> void
```

## Description

Copies the unit names currently displayed into the Recipient dropdown.

## Source

```gdscript
func set_recipients_from_units() -> void:
	_recipient_dd.clear()
	var root := _units_tree.get_root()
	if root:
		var ch := root.get_first_child()
		while ch:
			_recipient_dd.add_item(ch.get_text(0))
			ch = ch.get_next()
```
