# TriggerAPI::has_called_artillery Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 580–583)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_called_artillery() -> bool
```

- **Return Value**: True if at least one artillery mission has been called.

## Description

Check if any artillery fire missions have been called.
Returns true if at least one artillery mission has been requested.
  
  

**Usage in trigger expressions:**

```
# Trigger when first artillery is called
has_called_artillery()

# Tutorial: explain artillery usage
if has_called_artillery() and not has_global("artillery_tutorial_shown"):
set_global("artillery_tutorial_shown", true)
radio("Shot! Rounds on the way.")
show_dialog("Artillery takes time to impact. Listen for 'Splash' warning.")

# Complete objective when artillery called
if has_called_artillery():
complete_objective("call_fire_support")
```

## Source

```gdscript
func has_called_artillery() -> bool:
	return _artillery_called > 0
```
