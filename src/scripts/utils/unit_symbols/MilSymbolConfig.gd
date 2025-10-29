class_name MilSymbolConfig
extends Resource
## Configuration resource for military symbols
## Defines colors, sizes, and style settings for symbol generation

## Size categories for symbols
enum Size { SMALL = 64, MEDIUM = 128, LARGE = 256 }

## Affiliation types
enum Affiliation { FRIEND, HOSTILE, NEUTRAL, UNKNOWN }

## Base size for drawing coordinates (symbols are drawn in a 200x200 space)
const BASE_SIZE: float = 200.0

## Symbol size in pixels
@export var size: Size = Size.MEDIUM

## Resolution multiplier for anti-aliasing
## Higher values = smoother lines but larger texture memory
## 1 = native resolution, 2 = 2x resolution (recommended), 4 = 4x resolution
@export var resolution_scale: float = 2.0

## Stroke width for frame outlines
@export var stroke_width: float = 4.0

## Whether to fill the frame with color
@export var filled: bool = true

## Fill opacity (0.0 - 1.0)
@export var fill_opacity: float = 1.0

## Whether to draw the frame
@export var framed: bool = true

## Whether to draw icons
@export var show_icon: bool = true

## Font for text fields
@export var font_size: int = 48

## Colors for different affiliations (filled mode)
var fill_colors: Dictionary = {
	Affiliation.FRIEND: Color(0.5, 0.8, 1.0, 1.0),  ## Light blue
	Affiliation.HOSTILE: Color(1.0, 0.5, 0.5, 1.0),  ## Light red
	Affiliation.NEUTRAL: Color(0.5, 1.0, 0.5, 1.0),  ## Light green
	Affiliation.UNKNOWN: Color(1.0, 1.0, 0.5, 1.0)  ## Light yellow
}

## Colors for frame outlines
var frame_colors: Dictionary = {
	Affiliation.FRIEND: Color(0.0, 0.6, 1.0, 1.0),  ## Blue
	Affiliation.HOSTILE: Color(1.0, 0.0, 0.0, 1.0),  ## Red
	Affiliation.NEUTRAL: Color(0.0, 0.8, 0.0, 1.0),  ## Green
	Affiliation.UNKNOWN: Color(1.0, 1.0, 0.0, 1.0)  ## Yellow
}

## Color for icons
var icon_color: Color = Color.BLACK

## Color for text labels
var text_color: Color = Color.BLACK


## Get the actual pixel size for this configuration
func get_pixel_size() -> int:
	return size as int


## Get fill color for affiliation
func get_fill_color(affiliation: Affiliation) -> Color:
	return fill_colors.get(affiliation, Color.WHITE)


## Get frame color for affiliation
func get_frame_color(affiliation: Affiliation) -> Color:
	return frame_colors.get(affiliation, Color.BLACK)


## Create a default configuration
static func create_default() -> MilSymbolConfig:
	return MilSymbolConfig.new()


## Create a configuration for frame-only symbols (no fill)
## Useful for outline-style unit symbols
## Uses white lines for easy color modulation
static func create_frame_only() -> MilSymbolConfig:
	var config := MilSymbolConfig.new()
	config.filled = false

	# Set all frame colors to white for easy modulation
	config.frame_colors[Affiliation.FRIEND] = Color.WHITE
	config.frame_colors[Affiliation.HOSTILE] = Color.WHITE
	config.frame_colors[Affiliation.NEUTRAL] = Color.WHITE
	config.frame_colors[Affiliation.UNKNOWN] = Color.WHITE

	# Set icon and text colors to white as well
	config.icon_color = Color.WHITE
	config.text_color = Color.WHITE

	return config
