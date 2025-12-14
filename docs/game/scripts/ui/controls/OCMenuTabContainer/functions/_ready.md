# OCMenuTabContainer::_ready Function Reference

*Defined at:* `scripts/ui/controls/OcMenuTabContainer.gd` (lines 18–26)</br>
*Belongs to:* [OCMenuTabContainer](../../OCMenuTabContainer.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_tab_bar = get_tab_bar()
	if _tab_bar:
		_tab_bar.gui_input.connect(_on_tab_bar_input)
		_tab_bar.mouse_exited.connect(_on_tab_bar_mouse_exited)

	tab_changed.connect(_on_tab_changed)
```
