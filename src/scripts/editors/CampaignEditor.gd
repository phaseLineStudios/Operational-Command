extends Control
## In-game campaign editor for custom campaigns.
##
## Lets creators create campaigns

@onready var back_btn: Button = %Back

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	back_btn.connect("pressed", _on_back_pressed)

func _on_back_pressed():
	Game.goto_scene(MAIN_MENU_SCENE)
