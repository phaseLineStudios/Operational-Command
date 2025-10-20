class_name ThemeGenerator
extends Control
## Creates and saves a dark UI Theme that matches the campaign map.

signal theme_saved(path: String)

@export var regenerate_theme := false
@export_file("*.theme") var save_path := "res://assets/primary.theme"

@export_group("Fonts (optional)")
@export_file("*.ttf","*.otf") var ui_font_path := ""
@export_file("*.ttf","*.otf") var condensed_font_path := ""
@export_file("*.ttf","*.otf") var mono_font_path := ""

@export_group("Sizes")
@export_range(10, 28, 1) var font_size := 14
@export_range(0, 24, 1) var radius := 12
@export_range(0, 6, 1) var stroke_w := 1
@export_range(0, 16, 1) var shadow := 6
@export_range(0, 16, 1) var pad := 10

# Palette (matches map)
const C_BG        := Color8(11, 12, 15)
const C_WEST      := Color8(34, 38, 45)
const C_EAST      := Color8(28, 31, 36)
const C_STROKE_IN := Color8(70, 76, 86)
const C_STROKE_OUT:= Color8(90, 97, 110)
const C_TEXT      := Color8(160, 168, 180, 230)
const C_TEXT_DIM  := Color8(124, 133, 147, 200)
const C_TEXT_DIS  := Color8(77, 83, 93, 200)
const C_ACCENT    := Color8(180, 70, 70)
const C_SEL_BG    := Color8(43, 58, 70, 180)
const C_HOVER     := Color8(48, 55, 64, 200)
const C_PRESSED   := Color8(36, 42, 50, 220)
const C_INPUT_BG  := Color8(24, 27, 32, 255)
const C_TOOLTIP   := Color8(18, 19, 22, 240)
const C_GRIDLINE  := Color8(40, 44, 51, 140)

func _ready() -> void:
	if not regenerate_theme: 
		return
	var new_theme := build_theme()
	var err := ResourceSaver.save(new_theme, save_path)
	if err != OK:
		push_error("Failed to save theme: %s" % save_path)
		return
	emit_signal("theme_saved", save_path)
	print("Saved theme:", save_path)

## Build theme resource.
func build_theme() -> Theme:
	var t := Theme.new()
	_apply_fonts(t)
	_apply_base_colors(t)
	_panel(t); _labels(t); _buttons(t); _inputs(t)
	_scrollbars(t); _progress(t); _checks_and_options(t)
	_tabs_and_windows(t); _lists_and_trees(t); _tooltips(t)
	return t

# --- Fonts (Godot 4.5-correct) -----------------------------------------------

## Load a Font from res://, falling back to dynamic load for external/user://.
func _load_font(path: String) -> Font:
	if path.is_empty():
		return null
	if ResourceLoader.exists(path):
		return load(path) as Font
	var ff := FontFile.new()
	var err := ff.load_dynamic_font(path)
	if err != OK:
		push_warning("Could not load font at %s" % path)
	return ff

## Apply default fonts and sizes. Sizes are set on the Theme, not on FontFile.
func _apply_fonts(t: Theme) -> void:
	var ui_font: Font = _load_font(ui_font_path)
	if ui_font == null:
		ui_font = get_theme_default_font()

	t.set_font("font", "Control", ui_font)
	t.set_font_size("font_size", "Control", font_size)

	# Label default
	t.set_font("font", "Label", ui_font)
	t.set_font_size("font_size", "Label", font_size)

	# Optional condensed for dense labels / RichTextLabel
	if not condensed_font_path.is_empty():
		var condensed := _load_font(condensed_font_path)
		if condensed:
			t.set_font("font", "RichTextLabel", condensed)
			t.set_font_size("font_size", "RichTextLabel", font_size - 1)

	# Optional monospaced for editors/console
	if not mono_font_path.is_empty():
		var mono := _load_font(mono_font_path)
		if mono:
			for cls in ["TextEdit", "CodeEdit", "LineEdit"]:
				t.set_font("font", cls, mono)
				t.set_font_size("font_size", cls, font_size)

# --- Helpers ------------------------------------------------------------------
func _box(bg: Color, border: Color, bw: int = stroke_w, r: int = radius, sh: int = shadow, sh_col: Color = C_BG.darkened(0.2)) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(r)
	sb.set_border_width_all(bw)
	sb.border_color = border
	sb.shadow_size = sh
	sb.shadow_color = sh_col
	sb.content_margin_left = pad
	sb.content_margin_right = pad
	sb.content_margin_top = pad
	sb.content_margin_bottom = pad
	return sb

# --- Base / Panels ------------------------------------------------------------
func _apply_base_colors(t: Theme) -> void:
	t.set_color("font_color", "Control", C_TEXT)
	t.set_color("font_disabled_color", "Control", C_TEXT_DIS)
	t.set_color("font_outline_color", "Control", Color.TRANSPARENT)
	t.set_constant("outline_size", "Control", 0)

func _panel(t: Theme) -> void:
	t.set_stylebox("panel", "Panel", _box(C_BG, C_STROKE_OUT, 1, radius, 8, Color8(0,0,0,120)))
	t.set_stylebox("panel", "MarginContainer", _box(C_BG, Color.TRANSPARENT, 0, 0, 0))
	t.set_color("separator_color", "Separator", C_GRIDLINE)
	t.set_constant("separation", "HBoxContainer", 8)
	t.set_constant("separation", "VBoxContainer", 8)

# --- Labels -------------------------------------------------------------------
func _labels(t: Theme) -> void:
	t.set_color("font_color", "Label", C_TEXT)
	t.set_color("font_shadow_color", "Label", Color.TRANSPARENT)
	t.set_color("font_color", "RichTextLabel", C_TEXT_DIM)

# --- Buttons ------------------------------------------------------------------
func _buttons(t: Theme) -> void:
	var normal  := _box(C_WEST, C_STROKE_IN)
	var hover   := _box(C_HOVER, C_STROKE_OUT)
	var pressed := _box(C_PRESSED, C_STROKE_OUT)
	var disabled:= _box(C_WEST.darkened(0.15), C_STROKE_IN.darkened(0.2))
	var focus   := _box(C_SEL_BG, C_ACCENT, 2)
	for key in ["normal","hover","pressed","disabled","focus"]:
		pass
	t.set_stylebox("normal", "Button", normal)
	t.set_stylebox("hover", "Button", hover)
	t.set_stylebox("pressed", "Button", pressed)
	t.set_stylebox("disabled", "Button", disabled)
	t.set_stylebox("focus", "Button", focus)
	t.set_color("font_color", "Button", C_TEXT)
	t.set_color("font_hover_color", "Button", C_TEXT)
	t.set_color("font_pressed_color", "Button", C_TEXT)
	t.set_color("font_disabled_color", "Button", C_TEXT_DIS)
	t.set_color("icon_normal_color", "Button", C_TEXT_DIM)
	t.set_color("icon_hover_color", "Button", C_TEXT)
	t.set_color("icon_pressed_color", "Button", C_TEXT)
	t.set_constant("hseparation", "Button", 8)

# --- Inputs -------------------------------------------------------------------
func _inputs(t: Theme) -> void:
	var le_normal := _box(C_INPUT_BG, C_STROKE_IN)
	var le_focus  := _box(C_INPUT_BG.lightened(0.02), C_ACCENT, 2)
	var le_ro     := _box(C_INPUT_BG.darkened(0.05), C_STROKE_IN)
	t.set_stylebox("normal", "LineEdit", le_normal)
	t.set_stylebox("focus", "LineEdit", le_focus)
	t.set_stylebox("read_only", "LineEdit", le_ro)
	t.set_color("font_color", "LineEdit", C_TEXT)
	t.set_color("placeholder_color", "LineEdit", C_TEXT_DIM)
	t.set_color("clear_button_color", "LineEdit", C_TEXT_DIM)

	var te := _box(C_INPUT_BG, C_STROKE_IN)
	t.set_stylebox("normal", "TextEdit", te)
	t.set_stylebox("focus", "TextEdit", _box(C_INPUT_BG, C_ACCENT, 2))
	t.set_color("font_color", "TextEdit", C_TEXT)
	t.set_color("caret_color", "TextEdit", C_ACCENT)
	t.set_color("line_number_color", "TextEdit", C_TEXT_DIM)
	t.set_color("current_line_color", "TextEdit", C_SEL_BG)

	var s_track := _box(C_GRIDLINE, Color.TRANSPARENT, 0, radius, 0)
	var s_grab  := _box(C_WEST, C_STROKE_OUT)
	for cls in ["HSlider","VSlider"]:
		t.set_stylebox("slider", cls, s_track)
		t.set_stylebox("grabber", cls, s_grab)
		t.set_stylebox("grabber_highlight", cls, _box(C_HOVER, C_STROKE_OUT))
		t.set_stylebox("grabber_pressed", cls, _box(C_PRESSED, C_STROKE_OUT))
	t.set_color("updown_icon_modulate", "SpinBox", C_TEXT)

# --- Scrollbars ---------------------------------------------------------------
func _scrollbars(t: Theme) -> void:
	# Thin track (no padding)
	var track := StyleBoxFlat.new()
	track.bg_color = Color.TRANSPARENT
	track.set_corner_radius_all(4)
	track.set_border_width_all(0)
	track.content_margin_left = 0
	track.content_margin_right = 0
	track.content_margin_top = 0
	track.content_margin_bottom = 0

	# Small grabber with minimal padding
	var grab := StyleBoxFlat.new()
	grab.bg_color = C_WEST
	grab.border_color = C_STROKE_IN
	grab.set_border_width_all(1)
	grab.set_corner_radius_all(6)
	grab.content_margin_left = 2
	grab.content_margin_right = 2
	grab.content_margin_top = 2
	grab.content_margin_bottom = 2

	var grab_h := grab.duplicate()
	grab_h.bg_color = C_HOVER
	var grab_p := grab.duplicate()
	grab_p.bg_color = C_PRESSED

	for cls in ["ScrollBar","HScrollBar","VScrollBar"]:
		t.set_stylebox("scroll", cls, track)
		t.set_stylebox("grabber", cls, grab)
		t.set_stylebox("grabber_highlight", cls, grab_h)
		t.set_stylebox("grabber_pressed", cls, grab_p)

	t.set_constant("scrollbar_width", "ScrollContainer", 6)

# --- Progress / Status --------------------------------------------------------
func _progress(t: Theme) -> void:
	t.set_stylebox("background", "ProgressBar", _box(C_WEST.darkened(0.2), C_STROKE_IN))
	t.set_stylebox("fill", "ProgressBar", _box(C_SEL_BG, C_STROKE_OUT))
	t.set_color("font_color", "ProgressBar", C_TEXT)

# --- CheckBox / OptionButton / Menus -----------------------------------------
func _checks_and_options(t: Theme) -> void:
	var cb := _box(C_WEST, C_STROKE_IN)
	for cls in ["CheckBox", "CheckButton"]:
		t.set_stylebox("normal", cls, cb)
		t.set_stylebox("hover", cls, _box(C_HOVER, C_STROKE_OUT))
		t.set_stylebox("pressed", cls, _box(C_PRESSED, C_STROKE_OUT))
		t.set_color("font_color", cls, C_TEXT)
	t.set_color("checkmark_color", "CheckBox", C_ACCENT)

	for cls in ["OptionButton"]:
		t.set_stylebox("normal", cls, _box(C_WEST, C_STROKE_IN))
		t.set_stylebox("hover", cls, _box(C_HOVER, C_STROKE_OUT))
		t.set_stylebox("pressed", cls, _box(C_PRESSED, C_STROKE_OUT))

	var pm := _box(C_BG, C_STROKE_OUT, 1, radius, 8)
	t.set_stylebox("panel", "PopupMenu", pm)
	t.set_color("font_color", "PopupMenu", C_TEXT)
	t.set_color("font_disabled_color", "PopupMenu", C_TEXT_DIS)
	t.set_color("accent_color", "PopupMenu", C_ACCENT)
	t.set_color("selection_color", "PopupMenu", C_SEL_BG)

# --- Tabs / Windows -----------------------------------------------------------
func _tabs_and_windows(t: Theme) -> void:
	t.set_stylebox("panel", "TabContainer", _box(C_BG, C_STROKE_OUT))
	t.set_stylebox("tab_unselected", "TabContainer", _box(C_WEST, C_STROKE_IN))
	t.set_stylebox("tab_selected", "TabContainer", _box(C_SEL_BG, C_STROKE_OUT))
	t.set_stylebox("tab_hovered", "TabContainer", _box(C_HOVER, C_STROKE_OUT))
	t.set_stylebox("panel", "Window", _box(C_BG, C_STROKE_OUT, 1, radius, 10))
	t.set_color("title_color", "Window", C_TEXT)
	t.set_color("close_h_color", "Window", C_ACCENT)

# --- Lists / Trees ------------------------------------------------------------
func _lists_and_trees(t: Theme) -> void:
	t.set_stylebox("panel", "ItemList", _box(C_BG, C_STROKE_OUT))
	t.set_color("font_color", "ItemList", C_TEXT)
	t.set_color("font_hovered_color", "ItemList", C_TEXT)
	t.set_color("font_selected_color", "ItemList", C_TEXT)
	t.set_color("selection_color", "ItemList", C_SEL_BG)
	t.set_stylebox("panel", "Tree", _box(C_BG, C_STROKE_OUT))
	t.set_color("font_color", "Tree", C_TEXT)
	t.set_color("guide_color", "Tree", C_GRIDLINE)
	t.set_color("selection_color", "Tree", C_SEL_BG)

func _tooltips(t: Theme) -> void:
	t.set_stylebox("panel", "TooltipPanel", _box(C_TOOLTIP, C_STROKE_OUT, 1, radius, 8))
	t.set_color("font_color", "TooltipLabel", C_TEXT)
