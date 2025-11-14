# AIController::unregister_all_units Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 88–97)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func unregister_all_units() -> void
```

## Description

Remove all registered units and dispose of their agents/runners.

## Source

```gdscript
func unregister_all_units() -> void:
	var runner_ids := _runners.keys()
	for uid in runner_ids:
		unregister_unit(uid)
	if not _agents.is_empty():
		var agent_ids := _agents.keys()
		for uid in agent_ids:
			unregister_unit(uid)
```
