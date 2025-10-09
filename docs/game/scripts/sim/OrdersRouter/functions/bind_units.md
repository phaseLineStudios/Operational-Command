# OrdersRouter::bind_units Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 43–47)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void
```

## Description

Supply unit indices used by this router.
[param id_index] Dictionary String->ScenarioUnit (by unit id).
[param callsign_index] Dictionary String->unit_id (by callsign).

## Source

```gdscript
func bind_units(id_index: Dictionary, callsign_index: Dictionary) -> void:
	_units_by_id = id_index
	_units_by_callsign = callsign_index
```
