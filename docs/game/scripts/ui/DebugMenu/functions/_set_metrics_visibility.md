# DebugMenu::_set_metrics_visibility Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 38–41)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _set_metrics_visibility(visibility: int)
```

## Description

Set visibility for metrics display

## Source

```gdscript
func _set_metrics_visibility(visibility: int):
	metrics_display.style = visibility as DebugMetricsDisplay.Style
```
