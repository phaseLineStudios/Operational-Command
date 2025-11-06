# Symbol Drawing Tool

A visual tool for creating unit symbol icons and generating GDScript code for UnitSymbolGenerator.

## Purpose

Instead of manually writing drawing code, use this tool to:
1. Draw your unit symbol visually
2. Generate the corresponding GDScript code
3. Copy and paste into UnitSymbolGenerator

## How to Use

### 1. Open the Scene

Open `src/scenes/test/symbol_drawing_tool.tscn` in Godot and run it (F6).

### 2. Draw Your Symbol

- **Click and drag** in the canvas to draw lines
- The **blue box** shows the icon drawing area (48x48 pixels)
- The **red crosshairs** mark the center point (0, 0)
- The **grid** helps with alignment
- Draw multiple strokes as needed

### 3. Generate Code

Click the **"Generate Code"** button to generate GDScript code.

### 4. Copy the Code

Click **"Copy to Clipboard"** to copy the generated code.

### 5. Paste into UnitSymbolGenerator

Paste the code into `UnitSymbolGenerator.gd`:

```gdscript
## Draw your custom icon.
## [param img] Image.
## [param center] Center position.
## [param size] Icon size.
func _draw_my_custom_icon(img: Image, center: Vector2, size: float) -> void:
    var half := size / 2.0
    var thickness := 3.0

    # [PASTE GENERATED CODE HERE]
```

Then register it in `_register_default_icons()`:

```gdscript
func _register_default_icons() -> void:
    register_icon("infantry", _draw_infantry_icon)
    register_icon("armor", _draw_armor_icon)
    # ... existing icons ...
    register_icon("my_custom", _draw_my_custom_icon)  # Add this
```

## Example Workflow

### Drawing a Tank Destroyer Icon

1. Run the tool
2. Draw a circle (for gun barrel)
3. Draw a horizontal line through it (for barrel)
4. Click "Generate Code"
5. Copy and paste into a new function `_draw_tank_destroyer_icon()`
6. Register: `register_icon("tank_destroyer", _draw_tank_destroyer_icon)`

### Generated Code Example

```gdscript
## Draw custom icon.
## [param img] Image.
## [param center] Center position.
## [param size] Icon size.
func _draw_custom_icon(img: Image, center: Vector2, size: float) -> void:
	var half := size / 2.0
	var thickness := 3.0

	# Stroke 1
	_draw_thick_line(
		img, Vector2(center.x - half * 0.50, center.y - half * 0.25),
		Vector2(center.x - half * 0.38, center.y - half * 0.19),
		COLOR_FRAME, thickness
	)
	_draw_thick_line(
		img, Vector2(center.x - half * 0.38, center.y - half * 0.19),
		Vector2(center.x - half * 0.25, center.y - half * 0.13),
		COLOR_FRAME, thickness
	)
	# ... more lines ...
```

## Tips

### For Best Results

- **Stay within the blue box** - This is the icon drawing area
- **Use the center** - The red crosshairs mark center (0, 0)
- **Keep it simple** - Complex symbols are hard to recognize at small sizes
- **Draw clean lines** - Drag slowly for smoother strokes
- **Test it** - After pasting, generate a symbol to see how it looks

### Common Symbols

| Symbol Type | Recommended Drawing |
|-------------|---------------------|
| **Wheeled Vehicles** | Circle or oval |
| **Support** | Triangle |
| **Signal** | Lightning bolt or wavy lines |
| **Medical** | Cross |
| **Transport** | Rectangle with wheels |
| **Anti-Aircraft** | Circle with arrows |

### Coordinate System

- **Center**: (0, 0)
- **Top-left**: (-half, -half)
- **Top-right**: (+half, -half)
- **Bottom-left**: (-half, +half)
- **Bottom-right**: (+half, +half)

The generated code uses relative coordinates (e.g., `center.x + half * 0.5`) so your symbol scales correctly.

## Troubleshooting

### Code doesn't work when pasted

- Make sure you paste inside a function
- Ensure the function signature matches the pattern
- Check that `_draw_thick_line()` is accessible

### Symbol looks wrong

- Redraw with cleaner strokes
- Check the blue box boundaries
- Simplify complex paths

### Want to edit generated code

Feel free to manually adjust the generated coordinates and thickness values!

## Technical Details

### Canvas Size
- **Canvas**: 128x128 pixels (matches UnitSymbolGenerator.SYMBOL_SIZE)
- **Icon area**: 48x48 pixels (matches UnitSymbolGenerator.ICON_SIZE)

### Coordinate Conversion
The tool converts your pixel coordinates to normalized offsets:
- Canvas pixels → Normalized (-1.0 to +1.0) → `half * value`

### Output Format
```gdscript
_draw_thick_line(
    img,
    Vector2(center.x [± half * X], center.y [± half * Y]),
    Vector2(center.x [± half * X], center.y [± half * Y]),
    COLOR_FRAME,
    thickness
)
```

## File Location

- **Scene**: `src/scenes/test/symbol_drawing_tool.tscn`
- **Script**: `src/scripts/test/SymbolDrawingTool.gd`
