# UnitCard::_notification Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 98–104)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _notification(what: int) -> void
```

## Description

Cache laid-out size for drag preview.

## Source

```gdscript
func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_cached_size = size
	elif what == NOTIFICATION_RESIZED:
		_cached_size = size
```
