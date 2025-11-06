# TriggerAPI::get_artillery_calls Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 600–603)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_artillery_calls() -> int
```

- **Return Value**: Number of artillery missions called.

## Description

Get the number of artillery fire missions called.
  
  

**Usage in trigger expressions:**

```
# Trigger when 3 fire missions called
get_artillery_calls() >= 3

# Radio report on fire support usage
var count = get_artillery_calls()
radio("We've called " + str(count) + " fire mission(s) so far")

# Tutorial: warn about ammo conservation
if get_artillery_calls() > 5:
show_dialog("Watch your artillery ammunition - you only have limited rounds!")
```

## Source

```gdscript
func get_artillery_calls() -> int:
	return _artillery_called
```
