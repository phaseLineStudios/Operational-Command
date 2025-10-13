# UnitSelect::_connect_ui Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 75–91)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _connect_ui() -> void
```

## Description

Connect UI actions to methods

## Source

```gdscript
func _connect_ui() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_btn_reset.pressed.connect(_on_reset_pressed)
	_btn_deploy.pressed.connect(_on_deploy_pressed)

	for b in [
		_filter_all, _filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support
	]:
		b.toggled.connect(func(_p): _on_filter_changed(b))
	_search.text_changed.connect(_on_filter_text_changed)

	_slots_list.request_assign_drop.connect(_on_request_assign_drop)
	_slots_list.request_inspect_unit.connect(_on_request_inspect_from_tree)

	_pool.request_return_to_pool.connect(_on_request_return_to_pool)
```
