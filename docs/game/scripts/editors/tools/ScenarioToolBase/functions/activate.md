# ScenarioToolBase::activate Function Reference

*Defined at:* `scripts/editors/tools/ScenarioToolBase.gd` (lines 23–27)</br>
*Belongs to:* [ScenarioToolBase](../ScenarioToolBase.md)

**Signature**

```gdscript
func activate(ed: ScenarioEditor) -> void
```

## Description

Called by the editor when tool becomes active

## Source

```gdscript
func activate(ed: ScenarioEditor) -> void:
	editor = ed
	_on_activated()
```
