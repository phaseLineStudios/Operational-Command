# RadioFeedback::bind_ammo Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 28–35)</br>
*Belongs to:* [RadioFeedback](../RadioFeedback.md)

**Signature**

```gdscript
func bind_ammo(ammo: AmmoSystem) -> void
```

## Description

Bind to an AmmoSystem instance to receive ammo/resupply events.
Safe to call multiple times; connects the five signals used below.

## Source

```gdscript
func bind_ammo(ammo: AmmoSystem) -> void:
	ammo.ammo_low.connect(_on_ammo_low)
	ammo.ammo_critical.connect(_on_ammo_critical)
	ammo.ammo_empty.connect(_on_ammo_empty)
	ammo.resupply_started.connect(_on_resupply_started)
	ammo.resupply_completed.connect(_on_resupply_completed)
```
