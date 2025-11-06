# TriggerAPI::get_bridges_built Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 557–560)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_bridges_built() -> int
```

- **Return Value**: Number of bridges built.

## Description

Get the number of bridges built by engineers.
  
  

**Usage in trigger expressions:**

```
# Trigger when 2 bridges are built
get_bridges_built() >= 2

# Radio report on progress
var count = get_bridges_built()
radio("Engineers have completed " + str(count) + " bridge(s)")

# Tutorial: reinforce successful bridge building
if get_bridges_built() >= 3:
show_dialog("Excellent work! Your engineers are very efficient.")
```

## Source

```gdscript
func get_bridges_built() -> int:
	return _bridges_built
```
