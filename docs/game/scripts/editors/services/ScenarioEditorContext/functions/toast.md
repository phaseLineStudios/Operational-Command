# ScenarioEditorContext::toast Function Reference

*Defined at:* `scripts/editors/services/ScenarioEditorContext.gd` (lines 43–44)</br>
*Belongs to:* [ScenarioEditorContext](../ScenarioEditorContext.md)

**Signature**

```gdscript
func toast(msg: String) -> void
```

## Source

```gdscript
func toast(msg: String) -> void:
	toast_requested.emit(msg)
```
