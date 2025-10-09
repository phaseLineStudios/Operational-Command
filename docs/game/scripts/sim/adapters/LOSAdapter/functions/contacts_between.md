# LOSAdapter::contacts_between Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 63–69)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array
```

## Description

Builds contact pairs with clear LOS between [param friends] and [param enemies].
[param friends] Array of friendly ScenarioUnit.
[param enemies] Array of enemy ScenarioUnit.
[return] Array of Dictionaries: { \"attacker\": ScenarioUnit, \"defender\": ScenarioUnit }.

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
