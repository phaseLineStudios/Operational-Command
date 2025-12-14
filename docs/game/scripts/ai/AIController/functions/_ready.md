# AIController::_ready Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 50–58)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize controller and subscribe to sim engagement events for RETURN_FIRE.

## Source

```gdscript
func _ready() -> void:
	_resolve_context_nodes()
	# Wire return-fire window from SimWorld engagement events
	if _sim and not _sim.engagement_reported.is_connected(_on_engagement_reported):
		_sim.engagement_reported.connect(_on_engagement_reported)
	# Ensure runners tick via _physics_process
	set_physics_process(true)
```
