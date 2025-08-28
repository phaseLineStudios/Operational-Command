extends Control
## In-game terrain editor for custom terrains.
##
## Lets creators create terrains to use in scenarios.

@onready var file_menu: MenuButton = %File

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)

func _on_filemenu_pressed(id: int):
	if id == 3:
		Game.goto_scene(MAIN_MENU_SCENE)
