# AIAgent::_ready Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 31–35)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_ensure_adapter_refs()
	_on_adapters_changed()
```
