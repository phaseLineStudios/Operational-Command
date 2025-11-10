extends PanelContainer
## Document face with page navigation support

signal page_changed(page_index: int)

var current_page := 0
var total_pages := 1

@onready var paper_content: RichTextLabel = %PaperContent
@onready var page_indicator: Label = %PageIndicator
@onready var prev_button: Button = %PrevButton
@onready var next_button: Button = %NextButton


func _ready() -> void:
	# Connect button signals
	if prev_button:
		prev_button.pressed.connect(_on_prev_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)

	# Initial update
	update_page_indicator()


## Set the page indicator text and button visibility
func update_page_indicator() -> void:
	if page_indicator:
		if total_pages > 1:
			page_indicator.text = "Page %d/%d" % [current_page + 1, total_pages]
			page_indicator.visible = true
		else:
			page_indicator.visible = false

	# Update button states
	if prev_button:
		prev_button.visible = total_pages > 1
		prev_button.disabled = current_page <= 0

	if next_button:
		next_button.visible = total_pages > 1
		next_button.disabled = current_page >= total_pages - 1


## Handle previous button click
func _on_prev_pressed() -> void:
	prev_page()


## Handle next button click
func _on_next_pressed() -> void:
	next_page()


## Set the current page
func set_page(page: int) -> void:
	if page >= 0 and page < total_pages:
		current_page = page
		update_page_indicator()
		page_changed.emit(current_page)
	else:
		LogService.warning(
			"Invalid page %d (total: %d), ignoring" % [page, total_pages], "DocumentFace.gd"
		)


## Set total pages
func set_total_pages(count: int) -> void:
	total_pages = max(1, count)
	current_page = clampi(current_page, 0, total_pages - 1)
	update_page_indicator()


## Navigate to next page
func next_page() -> void:
	if current_page < total_pages - 1:
		set_page(current_page + 1)


## Navigate to previous page
func prev_page() -> void:
	if current_page > 0:
		set_page(current_page - 1)
