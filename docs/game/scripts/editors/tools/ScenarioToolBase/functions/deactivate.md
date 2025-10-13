# ScenarioToolBase::deactivate Function Reference

*Defined at:* `scripts/editors/tools/ScenarioToolBase.gd` (lines 29–33)</br>
*Belongs to:* [ScenarioToolBase](../../ScenarioToolBase.md)

**Signature**

```gdscript
func deactivate() -> void
```

## Description

Called when tool is removed

## Source

```gdscript
func deactivate() -> void:
	_on_deactivated()
	editor = null
```
