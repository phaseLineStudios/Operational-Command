# AIAgent::intent_wait_begin Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 208–212)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_wait_begin(seconds: float, until_contact: bool) -> void
```

## Source

```gdscript
func intent_wait_begin(seconds: float, until_contact: bool) -> void:
	_wait_timer = max(seconds, 0.0)
	_wait_until_contact = until_contact
```
