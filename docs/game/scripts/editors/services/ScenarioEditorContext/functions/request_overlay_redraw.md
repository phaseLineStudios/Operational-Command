# ScenarioEditorContext::request_overlay_redraw Function Reference

*Defined at:* `scripts/editors/services/ScenarioEditorContext.gd` (lines 35–38)</br>
*Belongs to:* [ScenarioEditorContext](../../ScenarioEditorContext.md)

**Signature**

```gdscript
func request_overlay_redraw() -> void
```

## Source

```gdscript
func request_overlay_redraw() -> void:
	overlay_redraw_requested.emit()
```
