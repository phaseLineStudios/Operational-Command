# LOSAdapter::contacts_between Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 127–135)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array
```

- **friends**: Array of friendly ScenarioUnit.
- **enemies**: Array of enemy ScenarioUnit.
- **Return Value**: Array of Dictionaries: { \"attacker\": ScenarioUnit, \"defender\": ScenarioUnit }.

## Description

Builds contact pairs with clear LOS between `friends` and `enemies`.

## Source

```gdscript
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array:
	var out: Array = []
	for f in friends:
		for e in enemies:
			if has_los(f, e):
				out.append({"attacker": f, "defender": e})
	return out
```
