class_name UnitConfigDialog
extends Window

## Edit a ScenarioUnit (callsign, affiliation, combat, behaviour)
##
## Double-click or context menu opens this dialog

var editor: ScenarioEditor
var unit_index := -1
var _before: ScenarioUnit

@onready var callsign_in: LineEdit = %Callsign
@onready var aff_in: OptionButton = %Affiliation
@onready var combat_in: OptionButton = %CombatMode
@onready var beh_in: OptionButton = %Behaviour
@onready var save_btn: Button = %Save
@onready var close_btn: Button = %Close


func _ready() -> void:
	if aff_in.item_count == 0:
		aff_in.add_item("Friendly", ScenarioUnit.Affiliation.friend)
		aff_in.add_item("Enemy", ScenarioUnit.Affiliation.enemy)

	if combat_in.item_count == 0:
		combat_in.add_item("Hold Fire", ScenarioUnit.CombatMode.forced_hold_fire)
		combat_in.add_item("Return Fire", ScenarioUnit.CombatMode.do_not_fire_unless_fired_upon)
		combat_in.add_item("Open Fire", ScenarioUnit.CombatMode.open_fire)

	if beh_in.item_count == 0:
		beh_in.add_item("Careless", ScenarioUnit.Behaviour.careless)
		beh_in.add_item("Safe", ScenarioUnit.Behaviour.safe)
		beh_in.add_item("Aware", ScenarioUnit.Behaviour.aware)
		beh_in.add_item("Combat", ScenarioUnit.Behaviour.combat)
		beh_in.add_item("Stealth", ScenarioUnit.Behaviour.stealth)

	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)


## Open dialog for a unit index in editor.ctx.data.units
func show_for(_editor: ScenarioEditor, index: int) -> void:
	editor = _editor
	unit_index = index
	var su: ScenarioUnit = editor.ctx.data.units[unit_index]
	_before = su.duplicate(true)

	callsign_in.text = su.callsign

	for i in aff_in.item_count:
		if aff_in.get_item_id(i) == int(su.affiliation):
			aff_in.select(i)
			break

	for i in combat_in.item_count:
		if combat_in.get_item_id(i) == int(su.combat_mode):
			combat_in.select(i)
			break

	for i in beh_in.item_count:
		if beh_in.get_item_id(i) == int(su.behaviour):
			beh_in.select(i)
			break

	visible = true


func _on_save() -> void:
	if not editor or unit_index < 0:
		return
	var su_live: ScenarioUnit = editor.ctx.data.units[unit_index]
	var after := su_live.duplicate(true)
	after.callsign = callsign_in.text.strip_edges()
	after.affiliation = aff_in.get_selected_id() as ScenarioUnit.Affiliation
	after.combat_mode = combat_in.get_selected_id() as ScenarioUnit.CombatMode
	after.behaviour = beh_in.get_selected_id() as ScenarioUnit.Behaviour

	if editor.history:
		var desc := "Edit Unit %s" % String(_before.callsign)
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "units", "id", String(su_live.id), _before, after, desc
		)
	else:
		su_live.callsign = after.callsign
		su_live.affiliation = after.affiliation
		su_live.combat_mode = after.combat_mode
		su_live.behaviour = after.behaviour

	visible = false
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()
