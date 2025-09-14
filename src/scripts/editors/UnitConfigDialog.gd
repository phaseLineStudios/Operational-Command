extends Window
class_name UnitConfigDialog

## Edit a ScenarioUnit (callsign, affiliation, combat, behaviour)
##
## Double-click or context menu opens this dialog

@onready var callsign_in: LineEdit     = %Callsign
@onready var aff_in: OptionButton      = %Affiliation
@onready var combat_in: OptionButton   = %CombatMode
@onready var beh_in: OptionButton      = %Behaviour
@onready var save_btn: Button          = %Save
@onready var close_btn: Button         = %Close

var editor: ScenarioEditor
var unit_index := -1

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
		beh_in.add_item("Safe",     ScenarioUnit.Behaviour.safe)
		beh_in.add_item("Aware",    ScenarioUnit.Behaviour.aware)
		beh_in.add_item("Combat",   ScenarioUnit.Behaviour.combat)
		beh_in.add_item("Stealth",  ScenarioUnit.Behaviour.stealth)

	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)

## Open dialog for a unit index in editor.data.units
func show_for(_editor: ScenarioEditor, index: int) -> void:
	editor = _editor
	unit_index = index
	var su: ScenarioUnit = editor.data.units[unit_index]

	callsign_in.text = su.callsign

	for i in aff_in.item_count:
		if aff_in.get_item_id(i) == int(su.affiliation):
			aff_in.select(i); break

	for i in combat_in.item_count:
		if combat_in.get_item_id(i) == int(su.combat_mode):
			combat_in.select(i); break

	for i in beh_in.item_count:
		if beh_in.get_item_id(i) == int(su.behaviour):
			beh_in.select(i); break

	visible = true

func _on_save() -> void:
	if not editor or unit_index < 0: return
	var su: ScenarioUnit = editor.data.units[unit_index]

	su.callsign   = callsign_in.text.strip_edges()
	su.affiliation = aff_in.get_selected_id() as ScenarioUnit.Affiliation
	su.combat_mode = combat_in.get_selected_id() as ScenarioUnit.CombatMode
	su.behaviour   = beh_in.get_selected_id() as ScenarioUnit.Behaviour

	visible = false
	editor._request_overlay_redraw()
	editor._rebuild_scene_tree()
