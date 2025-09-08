extends Resource
class_name BriefItemData

## Types of briefing item
enum ItemType { document, image }

## Unique identifier for this briefing item
@export var id: String
## Human-readable title of the briefing item
@export var title: String
## Type of the briefing item
@export var type: ItemType = ItemType.document
## Path to the resource backing this item
@export_file("*.* ; Any Resource") var resource
## Position of the item on the briefing board.
@export var board_position: Vector2

## Serializes Briefing Item to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"type": int(type),
		"resource_path": (resource if typeof(resource) == TYPE_STRING else (resource.resource_path if resource and resource.resource_path != "" else null)),
		"board_position": { "x": board_position.x, "y": board_position.y }
	}

## Deserializes briefing item from JSON
static func deserialize(data: Variant) -> BriefItemData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var b := BriefItemData.new()
	b.id = data.get("id", b.id)
	b.title = data.get("title", b.title)
	b.type = int(data.get("type", b.type))

	var res_path = data.get("resource_path", null)
	if res_path != null and typeof(res_path) == TYPE_STRING and res_path != "":
		var res := load(res_path)
		if res:
			b.resource = res

	var pos = data.get("board_position", null)
	if typeof(pos) == TYPE_DICTIONARY and pos.has("x") and pos.has("y"):
		b.board_position = Vector2(float(pos["x"]), float(pos["y"]))
	elif typeof(pos) == TYPE_ARRAY and pos.size() >= 2:
		b.board_position = Vector2(float(pos[0]), float(pos[1]))

	return b
