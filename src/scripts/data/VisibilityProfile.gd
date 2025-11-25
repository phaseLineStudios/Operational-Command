class_name VisibilityProfile
extends Resource
## Configuration for local visibility scoring and loss thresholds.
## This is a stub; populate fields and logic when implementing EnvBehaviorSystem.

# Weather/night multipliers and thresholds should be added here.
# Example placeholders:
@export var base_visibility_threshold: float = 0.5
@export var fog_visibility_penalty: float = 0.2
@export var night_visibility_penalty: float = 0.3

