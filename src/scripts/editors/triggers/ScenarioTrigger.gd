class_name ScenarioTrigger
extends Resource
## Generic, scriptable trigger with optional area/presence and timer.
## Evaluates each frame. runs on_activate/on_deactivate when switching state.

## Presence mode
enum PresenceMode {
	NONE,
	PLAYER_INSIDE,
	FRIEND_INSIDE,
	ENEMY_INSIDE,
	PLAYER_NOT_INSIDE,
	FRIEND_NOT_INSIDE,
	ENEMY_NOT_INSIDE
}
## Area Shape type
enum AreaShape { CIRCLE, RECT }

## Unique identifier of the trigger
@export var id: String = ""
## Trigger title
@export var title: String = "Trigger"
## Trigger icon
@export var icon: Texture2D = preload("res://assets/textures/ui/editors_trigger.png")
## Area shape.
@export var area_shape: AreaShape = AreaShape.CIRCLE
## Center of area in *terrain meters*
@export var area_center_m: Vector2 = Vector2.ZERO
## Area size in meters (width, height)
@export var area_size_m: Vector2 = Vector2(50, 50)
## Presence Mode
@export var presence: PresenceMode = PresenceMode.NONE
## Time (seconds) the combined condition must stay true before activation
@export var require_duration_s: float = 0.0
## Extra condition (must be true along with presence), evaluated every frame
@export_multiline var condition_expr: String = "true"
## Executed once on activation. Same variable scope as condition
@export_multiline var on_activate_expr: String = ""
## Executed once when condition becomes false after being active
@export_multiline var on_deactivate_expr: String = ""
## Synced editor units
@export var synced_units: Array[int] = []
## Synced editor tasks
@export var synced_tasks: Array[int] = []

@warning_ignore("unused_private_class_variable")
var _active: bool = false
@warning_ignore("unused_private_class_variable")
var _accum_true: float = 0.0


func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"area_center_m": ContentDB.v2(area_center_m),
		"shape": int(area_shape),
		"size_m": ContentDB.v2(area_size_m),
		"presence": int(presence),
		"require_duration_s": require_duration_s,
		"condition_expr": condition_expr,
		"on_activate_expr": on_activate_expr,
		"on_deactivate_expr": on_deactivate_expr,
		"synced_units": synced_units.duplicate(),
		"synced_tasks": synced_tasks.duplicate(),
	}


static func deserialize(d: Variant) -> ScenarioTrigger:
	if typeof(d) != TYPE_DICTIONARY:
		return null
	var t := ScenarioTrigger.new()
	t.id = d.get("id", "")
	t.title = d.get("title", "Trigger")
	t.area_shape = int(d.get("shape", AreaShape.CIRCLE)) as AreaShape
	if d.has("area_center_m") and typeof(d["area_center_m"]) == TYPE_DICTIONARY:
		t.area_center_m = ContentDB.v2_from(d["area_center_m"])
	t.area_size_m = ContentDB.v2_from(d.get("size_m", Vector2.ZERO))
	t.presence = int(d.get("presence", 0)) as PresenceMode
	t.require_duration_s = float(d.get("require_duration_s", 0.0))
	t.condition_expr = String(d.get("condition_expr", "true"))
	t.on_activate_expr = String(d.get("on_activate_expr", ""))
	t.on_deactivate_expr = String(d.get("on_deactivate_expr", ""))
	var su = d.get("synced_units", [])
	if typeof(su) == TYPE_ARRAY:
		var out_u: Array[int] = []
		for v in su:
			out_u.append(int(v))
		t.synced_units = out_u
	var st = d.get("synced_tasks", [])
	if typeof(st) == TYPE_ARRAY:
		var out_t: Array[int] = []
		for v in st:
			out_t.append(int(v))
		t.synced_tasks = out_t
	return t
