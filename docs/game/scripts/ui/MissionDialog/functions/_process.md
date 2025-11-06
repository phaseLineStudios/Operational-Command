# MissionDialog::_process Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 108–112)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func _process(_delta: float) -> void
```

## Description

Update line overlay every frame when visible

## Source

```gdscript
func _process(_delta: float) -> void:
	if _line_overlay and _line_overlay.visible:
		_line_overlay.queue_redraw()
```
