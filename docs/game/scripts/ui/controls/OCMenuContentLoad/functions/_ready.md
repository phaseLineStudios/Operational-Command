# OCMenuContentLoad::_ready Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContentLoad.gd` (lines 10–14)</br>
*Belongs to:* [OCMenuContentLoad](../../OCMenuContentLoad.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	super._ready()
	content_list = %ContentList

	content_list.item_selected.connect(func(idx: int): emit_signal("content_selected", idx))
```
