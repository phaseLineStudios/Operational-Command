# AIAgent::notify_hostile_shot Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 72–76)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func notify_hostile_shot() -> void
```

## Description

External notification that a hostile shot was observed against this unit.

## Source

```gdscript
func notify_hostile_shot() -> void:
	if _combat != null and _combat.has_method("report_hostile_shot_observed"):
		_combat.report_hostile_shot_observed()
```
