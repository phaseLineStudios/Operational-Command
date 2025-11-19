@tool
class_name OcMenuContentLoad
extends OcMenuWindow

var content_list: ItemList

func _ready() -> void:
	super._ready()
	content_list = %ContentList
