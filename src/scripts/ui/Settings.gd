class_name Settings
extends Control
## Settings controller
## Tabs: Video, Audio, Controls, Gameplay. Loads/applies/saves config.

signal back_requested

## Window modes.
enum WindowMode { WINDOWED, FULLSCREEN }

## Config path.
const CONFIG_PATH := "user://settings.cfg"

## Exposed buses. Missing buses are ignored.
@export var audio_buses: Array[String] = ["Master", "Music", "SFX", "UI", "Radio"]
## Actions to rebind (must exist in InputMap).
@export var actions_to_rebind: Array[String] = ["ptt"]
## Resolution list.
@export var resolutions: Array[Vector2i] = [
	Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768), Vector2i(1280, 720)
]
## Scene to navigate to on back (leave empty for no action)
@export var back_scene: PackedScene

var _bus_rows: Dictionary = {}  # name -> {slider: HSlider, label: Label, mute: CheckBox}
var _cfg := ConfigFile.new()

@onready var btn_back: Button = %Back
@onready var _btn_apply: Button = %Apply
@onready var _btn_defaults: Button = %Defaults

# Video
@onready var _mode: OptionButton = %Mode
@onready var _res: OptionButton = %Resolution
@onready var _vsync: CheckBox = %VSync
@onready var _scale: HSlider = %RenderScale
@onready var _scale_val: Label = %ScaleValue
@onready var _fps: SpinBox = %FPSCap

# Audio
@onready var _buses_list: GridContainer = %BusesList

# Controls
@onready var _controls_list: VBoxContainer = %ControlsList
@onready var _reset_bindings: Button = %ResetBindings
@onready var _rebind_template: Button = $"RebindTemplate"


## Build UI and load config.
func _ready() -> void:
	_build_video_ui()
	_build_audio_ui()
	_build_controls_ui()

	_load_config()
	_apply_ui_from_config()

	_connect_signals()


## Populate video controls.
func _build_video_ui() -> void:
	_mode.clear()
	_mode.add_item("Windowed", WindowMode.WINDOWED)
	_mode.add_item("Fullscreen", WindowMode.FULLSCREEN)

	_res.clear()
	for r in resolutions:
		_res.add_item("%dx%d" % [r.x, r.y])
	_res.select(0)

	_scale_val.text = "%d%%" % int(_scale.value)


## Create rows for each audio bus.
func _build_audio_ui() -> void:
	for audio_name in audio_buses:
		var idx := AudioServer.get_bus_index(audio_name)
		if idx == -1:
			continue
		var lab := Label.new()
		lab.text = audio_name
		var sli := HSlider.new()
		sli.min_value = 0.0
		sli.max_value = 1.0
		sli.step = 0.01
		sli.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sli.tick_count = 20
		sli.ticks_on_borders = true
		var val := Label.new()
		val.text = "0%"
		var mute := CheckBox.new()
		mute.text = "Mute"
		_buses_list.add_child(lab)
		_buses_list.add_child(sli)
		_buses_list.add_child(val)
		_buses_list.add_child(mute)
		_bus_rows[audio_name] = {"slider": sli, "label": val, "mute": mute}
		# Live preview
		sli.value_changed.connect(
			func(v: float):
				val.text = "%d%%" % int(round(v * 100.0))
				_set_bus_volume(audio_name, v)
		)
		mute.toggled.connect(func(on: bool): _set_bus_mute(audio_name, on))


## Create rebind buttons for actions.
func _build_controls_ui() -> void:
	for act in actions_to_rebind:
		if not InputMap.has_action(act):
			continue
		var row := HBoxContainer.new()
		var lab := Label.new()
		lab.text = act
		var btn := _rebind_template.duplicate() as Button
		btn.visible = true
		if btn.has_method("set_action"):
			btn.call("set_action", act)
		row.add_child(lab)
		row.add_child(btn)
		_controls_list.add_child(row)


## Wire up buttons and live labels.
func _connect_signals() -> void:
	btn_back.pressed.connect(
		func():
			if back_scene != null:
				Game.goto_scene(back_scene.resource_path)
			emit_signal("back_requested")
	)
	_btn_apply.pressed.connect(_apply_and_save)
	_btn_defaults.pressed.connect(_reset_defaults)
	_reset_bindings.pressed.connect(_reset_all_bindings)
	_scale.value_changed.connect(func(v: float): _scale_val.text = "%d%%" % int(v))


## Load config file (if present).
func _load_config() -> void:
	var err := _cfg.load(CONFIG_PATH)
	if err != OK:
		return


## Push saved values into UI.
func _apply_ui_from_config() -> void:
	# Video
	var video: Variant = _cfg.get_value("video", "mode", WindowMode.WINDOWED)
	_mode.select(int(video))
	var res_idx := int(_cfg.get_value("video", "res_index", 0))
	if res_idx >= 0 and res_idx < _res.item_count:
		_res.select(res_idx)
	_vsync.button_pressed = bool(_cfg.get_value("video", "vsync", true))
	_scale.value = float(_cfg.get_value("video", "scale_pct", 100))
	_scale_val.text = "%d%%" % int(_scale.value)
	_fps.value = float(_cfg.get_value("video", "fps_cap", 0))

	# Audio
	for audio_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[audio_name]
		var sli: HSlider = row["slider"]
		var mute: CheckBox = row["mute"]
		var vol := float(_cfg.get_value("audio", "%s_vol" % audio_name, 1.0))
		var m := bool(_cfg.get_value("audio", "%s_mute" % audio_name, false))
		sli.value = clampf(vol, 0.0, 1.0)
		mute.button_pressed = m
		_set_bus_volume(audio_name, sli.value)
		_set_bus_mute(audio_name, m)


## Apply settings and persist.
func _apply_and_save() -> void:
	_apply_video()
	_apply_audio()
	_apply_gameplay()
	_save_config()


## Reset to defaults.
func _reset_defaults() -> void:
	# Video defaults
	_mode.select(WindowMode.WINDOWED)
	_res.select(0)
	_vsync.button_pressed = true
	_scale.value = 100.0
	_fps.value = 0
	# Audio defaults
	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		(row["slider"] as HSlider).value = 1.0
		(row["mute"] as CheckBox).button_pressed = false
		_set_bus_volume(bus_name, 1.0)
		_set_bus_mute(bus_name, false)
	_apply_and_save()


## Remove custom bindings and restore defaults (uses InputSchema if present).
func _reset_all_bindings() -> void:
	if Engine.has_singleton("InputSchema"):
		var schema := Engine.get_singleton("InputSchema")
		if schema and schema.has_method("reset_to_defaults"):
			schema.call("reset_to_defaults")
	# Update button labels
	for node in _controls_list.get_children():
		for child in (node as HBoxContainer).get_children():
			if child is Button and child.has_method("refresh_label"):
				child.call("refresh_label")


## Apply video settings to the window/engine.
func _apply_video() -> void:
	var mode := _mode.get_selected_id()
	match mode:
		WindowMode.FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		_:
			get_window().mode = Window.MODE_WINDOWED
	var use_vsync := _vsync.button_pressed
	# Godot 4 vsync key may vary across templates; try both.
	if ProjectSettings.has_setting("display/window/vsync/vsync_mode"):
		ProjectSettings.set_setting("display/window/vsync/vsync_mode", 1 if use_vsync else 0)
	else:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", use_vsync)
	ProjectSettings.save()

	var idx := _res.get_selected()
	if idx >= 0 and idx < resolutions.size():
		var res_size := resolutions[idx]
		if get_window().mode == Window.MODE_WINDOWED:
			get_window().size = res_size

	Engine.max_fps = int(_fps.value)
	# Store render scale only; actual scaling strategy can be implemented later.
	# (Keeps groundwork without forcing a scaling mode right now.)


## Apply audio to buses.
func _apply_audio() -> void:
	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		_set_bus_volume(bus_name, (row["slider"] as HSlider).value)
		_set_bus_mute(bus_name, (row["mute"] as CheckBox).button_pressed)


## Apply gameplay flags.
func _apply_gameplay() -> void:
	pass


## Save config file.
func _save_config() -> void:
	_cfg.set_value("video", "mode", _mode.get_selected_id())
	_cfg.set_value("video", "res_index", _res.get_selected())
	_cfg.set_value("video", "vsync", _vsync.button_pressed)
	_cfg.set_value("video", "scale_pct", _scale.value)
	_cfg.set_value("video", "fps_cap", _fps.value)

	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		_cfg.set_value("audio", "%s_vol" % bus_name, (row["slider"] as HSlider).value)
		_cfg.set_value("audio", "%s_mute" % bus_name, (row["mute"] as CheckBox).button_pressed)

	_cfg.save(CONFIG_PATH)


## Set bus volume (linear 0..1).
func _set_bus_volume(bus_name: String, v: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(v, 0.0, 1.0)))


## Mute/unmute bus.
func _set_bus_mute(bus_name: String, on: bool) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	AudioServer.set_bus_mute(idx, on)


## Linear→dB helper.
func linear_to_db(v: float) -> float:
	return -80.0 if v <= 0.0001 else 20.0 * (log(v) / log(10.0))


## API to set settigns visibility
func set_visibility(state: bool):
	visible = state
	modulate = Color.WHITE  # Some engine bug modulates to color(0,0,0,0) on hide
