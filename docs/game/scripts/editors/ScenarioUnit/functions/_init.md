# ScenarioUnit::_init Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 57–61)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _init() -> void
```

## Source

```gdscript
func _init() -> void:
	_morale_sys = MoraleSystem.new(id, self)
	_morale = _morale_sys.get_morale()
```
