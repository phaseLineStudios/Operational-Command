class_name ViewportReadOverlay
extends CanvasLayer

signal closed

@export var close_on_background_click: bool = true
@export var forward_input_to_viewport: bool = false
@export var consume_escape: bool = false

var _viewport: SubViewport = null
var _viewport_size: Vector2i = Vector2i.ZERO

@onready var _root: Control = $Root
@onready var _background: ColorRect = $Root/Background
@onready var _title_label: Label = %TitleLabel
@onready var _close_button: Button = %CloseButton
@onready var _texture_rect: TextureRect = %ViewportTexture


func _ready() -> void:
	_background.mouse_filter = Control.MOUSE_FILTER_STOP
	_texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.mouse_filter = Control.MOUSE_FILTER_STOP

	_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	_close_button.pressed.connect(close)
	_background.gui_input.connect(_on_background_gui_input)
	_texture_rect.gui_input.connect(_on_texture_gui_input)


func open_viewport(viewport: SubViewport, title: String = "", forward_input: bool = true) -> void:
	_viewport = viewport
	_viewport_size = viewport.size
	forward_input_to_viewport = forward_input
	_title_label.text = title
	_texture_rect.texture = viewport.get_texture()


func open_texture(texture: Texture2D, title: String = "") -> void:
	_viewport = null
	_viewport_size = Vector2i.ZERO
	forward_input_to_viewport = false
	_title_label.text = title
	_texture_rect.texture = texture


func close() -> void:
	closed.emit()
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		close()
		if consume_escape:
			get_viewport().set_input_as_handled()


func _on_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		get_viewport().set_input_as_handled()
		close()

	if not forward_input_to_viewport or _viewport == null:
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		var vp_pos: Vector2 = _map_global_to_viewport_pos(mb.global_position)
		if not vp_pos.is_finite():
			return
		var forward := InputEventMouseButton.new()
		forward.button_index = mb.button_index
		forward.pressed = mb.pressed
		forward.double_click = mb.double_click
		forward.position = vp_pos
		forward.global_position = vp_pos
		_viewport.push_input(forward)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		var vp_pos_motion: Vector2 = _map_global_to_viewport_pos(mm.global_position)
		if not vp_pos_motion.is_finite():
			return
		var fmm := InputEventMouseMotion.new()
		fmm.position = vp_pos_motion
		fmm.global_position = vp_pos_motion
		fmm.relative = mm.relative
		fmm.velocity = mm.velocity
		_viewport.push_input(fmm)
		get_viewport().set_input_as_handled()


func _on_background_gui_input(event: InputEvent) -> void:
	if not close_on_background_click:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		close()


func _map_global_to_viewport_pos(global_pos: Vector2) -> Vector2:
	if _texture_rect.texture == null:
		return Vector2.INF
	if _viewport_size.x <= 0 or _viewport_size.y <= 0:
		return Vector2.INF

	var rect := _texture_rect.get_global_rect()
	var tex_size: Vector2 = _texture_rect.texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return Vector2.INF

	var scale: float = minf(rect.size.x / tex_size.x, rect.size.y / tex_size.y)
	if scale <= 0.0:
		return Vector2.INF

	var draw_size: Vector2 = tex_size * scale
	var draw_pos: Vector2 = rect.position + (rect.size - draw_size) * 0.5
	var draw_rect := Rect2(draw_pos, draw_size)
	if not draw_rect.has_point(global_pos):
		return Vector2.INF

	var local_tex: Vector2 = (global_pos - draw_pos) / scale
	var vp_size_v2 := Vector2(_viewport_size)
	return Vector2(
		local_tex.x * vp_size_v2.x / tex_size.x,
		local_tex.y * vp_size_v2.y / tex_size.y
	)
