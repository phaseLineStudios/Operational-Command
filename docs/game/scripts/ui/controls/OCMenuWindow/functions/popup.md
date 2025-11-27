# OCMenuWindow::popup Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 48–52)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func popup() -> void
```

## Description

Show dialog without changing position.

## Source

```gdscript
func popup() -> void:
	visible = true
	move_to_front()
```
