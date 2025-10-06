<p align="center">
    <img src="extras/logo/logo_badge.png" width="480">
</p>

<p align="center">
    <a href="#"><img alt="Project Status" src="https://img.shields.io/badge/Project%20Status-Prototype-%2397c900?style=flat"/></a>
    <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg"/></a>
</p>

<p align="center">
    <sup><strong>Requires the latest version of <a href="https://godotengine.org/releases/4.5/index.html">Godot 4.5</a> and <a href="https://www.python.org/downloads/">Python3.</a><br/></strong></sup>
</p>

*A Cold War RTS where you command from the map, not the turret.*

Operational Command (working title) is a tactical RTS built in **Godot 4.5**. You play as a NATO field officer in an alternate 1980s where the Cold War turns hot. Issue orders via a diegetic command-post interface, manage logistics and morale, and carry your force from mission to mission. See the [Game Design Doc](docs/game_design.md) for the full vision.

> Operation Command focuses on realistic planning, persistent units, and terrain-affected combat outcomes rather than click-speed micro.

## Features
- **Command-post gameplay:** plan on a tactical map with NATO symbology and tools (ruler, drawing, measurements).
- **Persistent campaign:** unit experience, losses, and logistics carry between missions.
- **Data-driven combat sim:** outcomes influenced by unit stats, morale, elevation, cover, weather, and visibility.
- **Voice-first command flow (optional):** built around radio-style command patterns.
- **Scenario tooling:** map/editor support for custom scenarios.

## Project Status
Active development (prototype/alpha). Expect breaking changes while systems settle.

## Quick Start

### Requirements
- **Godot 4.5.x (stable)**

### Run the game
1. Clone the repo and open it in Godot (`project.godot`).
2. Set the main scene if needed: **Project → Project Settings → Run → Main Scene**.
3. Press **Run**.

### Command line (headless / CI)
```bash
# Example: Format, lint and smoke compile all scripts and scenes
make all-fix
```
>Tip: Run `make help` for a comprehensive list of all make targets.

>Note: For smoke compile to work you need to have godot 4.5 on path, inside `tools/` or linked in `tools/GODOT_BIN`.

## Project Layout
```bash
dependencies/
  vosk_gd/               # Vosk GDExtension wrapper
docs/
  game_design.md         # High-level design
  gameprog.md            # Final delivery doc
extras/                  # Project related assets
src/
  scenes/                # Gameplay and UI scenes
  scripts/               # Game logic (GDScript)
  data/                  # Data, scenario assets, etc.
  assets/                # Game assets
  tools/                 # Custom tools
  addons/                # Godot editor plugins/extensions
tools/
  bump_godot_version.py  # Bump PATCH semver. (triggered on PR merge)
  gdtoolkit_run.py       # Format, lint and smoke test game files
  scene_linter.py        # custom godot scene linter
```

## Build, Run & CI
- **Local**: run from the editor (see Quick Start).
- **CI Smoke Compile**: res://tools/ci/smoke_compile.gd validates scripts compile headless.
- **Export Templates**: keep export presets checked in. Platform exports should be reproducible.

## Documentation
- **High-level**: [game_design.md](docs/game_design.md) (vision, gameplay, campaign).
- **Code style**: Following the [GDScript Style Guide](https://docs.godotengine.org/en/4.5/tutorials/scripting/gdscript/gdscript_styleguide.html). GDScript doc comments on `scripts`, `signals`, `enums`, `constants`, `@exports`, and `functions`.
- **In-code docs**: Prefer short, precise comments next to implementations.

## Contributing
- Read [CONTRIBUTING.md](CONTRIBUTING.md) for:
  - Dev setup and Workflow (branching, PRs, reviews)
  - Coding standards (GDScript docs format)
  - Testing & CI expectations
- Direct link to the workflow: [CONTRIBUTING → Workflow](CONTRIBUTING.md#Workflow)

## License
This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](LICENSE).


### Attribution
If you use, adapt, or share this work, please credit:

“Operational Command — © 2025 Phase Line Studios — CC BY-NC-SA 4.0”
https://creativecommons.org/licenses/by-nc-sa/4.0/

>Please include links to the original repository and list any changes you made.