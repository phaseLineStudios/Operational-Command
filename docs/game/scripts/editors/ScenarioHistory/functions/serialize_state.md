# ScenarioHistory::serialize_state Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 323–326)</br>
*Belongs to:* [ScenarioHistory](../../ScenarioHistory.md)

**Signature**

```gdscript
func serialize_state() -> Dictionary
```

## Description

Serialize history state for preservation (e.g., during playtest)

## Source

```gdscript
func serialize_state() -> Dictionary:
	return {"past": _past.duplicate(), "future": _future.duplicate()}
```
