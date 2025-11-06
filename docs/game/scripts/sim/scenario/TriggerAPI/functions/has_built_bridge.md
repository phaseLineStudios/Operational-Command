# TriggerAPI::has_built_bridge Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 537–540)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_built_bridge() -> bool
```

- **Return Value**: True if at least one bridge has been built.

## Description

Check if any engineers have built a bridge.
Returns true if at least one bridge has been completed.
  
  

**Usage in trigger expressions:**

```
# Trigger when first bridge is built
has_built_bridge()

# Tutorial: explain bridge building
if has_built_bridge() and not has_global("bridge_tutorial_shown"):
set_global("bridge_tutorial_shown", true)
radio("Well done! The bridge is complete.")
show_dialog("Engineers can build bridges across water obstacles.")

# Complete objective when bridge built
if has_built_bridge():
complete_objective("build_crossing")
```

## Source

```gdscript
func has_built_bridge() -> bool:
	return _bridges_built > 0
```
