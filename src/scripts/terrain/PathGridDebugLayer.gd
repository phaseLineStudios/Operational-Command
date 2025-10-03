class_name PathGridDebugLayer
extends Control

## Simple on-canvas PathGrid visualizer

@export var grid: PathGrid


func _draw() -> void:
	if grid:
		grid.debug_draw_overlay(self)


func _process(_d: float) -> void:
	if grid and grid.debug_enabled:
		queue_redraw()
