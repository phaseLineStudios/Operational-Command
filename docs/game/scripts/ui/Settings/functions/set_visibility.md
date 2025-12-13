# Settings::set_visibility Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 355–357)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func set_visibility(state: bool)
```

## Description

API to set settigns visibility

## Source

```gdscript
func set_visibility(state: bool):
	visible = state
	modulate = Color.WHITE  # Some engine bug modulates to color(0,0,0,0) on hide
```
