@tool
class_name OcMenuContentLoad
extends OcMenuWindow

signal content_selected(index: int)

var content_list: ItemList

func _ready() -> void:
	super._ready()
	content_list = %ContentList
	
	content_list.item_selected.connect(func(idx: int): emit_signal("content_selected", idx))
