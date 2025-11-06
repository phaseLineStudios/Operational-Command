# MilSymbolTest::_ready Function Reference

*Defined at:* `scripts/test/MilSymbolTest.gd` (lines 29–47)</br>
*Belongs to:* [MilSymbolTest](../../MilSymbolTest.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	config = MilSymbolConfig.create_default()
	config.size = MilSymbolConfig.Size.MEDIUM
	generator = MilSymbol.new(config)

	_refresh_options()

	u_type.item_selected.connect(func(_idx: int): _generate_symbols())
	u_size.item_selected.connect(func(_idx: int): _generate_symbols())
	u_modifier_1.item_selected.connect(func(_idx: int): _generate_symbols())
	u_modifier_2.item_selected.connect(func(_idx: int): _generate_symbols())
	u_status.item_selected.connect(func(_idx: int): _generate_symbols())
	u_reinforced_reduced.item_selected.connect(func(_idx: int): _generate_symbols())
	u_frame.pressed.connect(func(): _generate_symbols())
	refresh_btn.pressed.connect(func(): _on_refresh())

	_generate_symbols()
```
